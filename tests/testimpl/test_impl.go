package testimpl

import (
	"context"
	"os"
	"testing"

	"github.com/Azure/azure-sdk-for-go/sdk/azcore"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/arm"
	"github.com/Azure/azure-sdk-for-go/sdk/azcore/cloud"
	"github.com/Azure/azure-sdk-for-go/sdk/azidentity"
	operationalinsights "github.com/Azure/azure-sdk-for-go/sdk/resourcemanager/operationalinsights/armoperationalinsights/v2"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
)

func TestComposableComplete(t *testing.T, ctx types.TestContext) {
	subscriptionID := os.Getenv("ARM_SUBSCRIPTION_ID")
	if len(subscriptionID) == 0 {
		t.Fatal("ARM_SUBSCRIPTION_ID is not set in the environment variables ")
	}

	credential, err := azidentity.NewDefaultAzureCredential(nil)
	if err != nil {
		t.Fatalf("Unable to get credentials: %e\n", err)
	}

	options := arm.ClientOptions{
		ClientOptions: azcore.ClientOptions{
			Cloud: cloud.AzurePublic,
		},
	}

	resourceGroupName := terraform.Output(t, ctx.TerratestTerraformOptions(), "resource_group_name")
	workspaceName := terraform.Output(t, ctx.TerratestTerraformOptions(), "workspace_name")
	workspaceId := terraform.Output(t, ctx.TerratestTerraformOptions(), "workspace_id")
	storageAccountId := terraform.Output(t, ctx.TerratestTerraformOptions(), "storage_account_id")
	datasourceType := operationalinsights.DataSourceTypeCustomLogs // this is the type used in the example

	logAnalyticsWorkspaceClient, err := operationalinsights.NewWorkspacesClient(subscriptionID, credential, &options)
	if err != nil {
		t.Fatalf("Error creating log analytics workspace client: %v", err)
	}

	linkedStorageAccountsClient, err := operationalinsights.NewLinkedStorageAccountsClient(subscriptionID, credential, &options)
	if err != nil {
		t.Fatalf("Error creating linked storage accounts client: %v", err)
	}

	workspace, err := logAnalyticsWorkspaceClient.Get(context.Background(), resourceGroupName, workspaceName, nil)
	if err != nil {
		t.Fatalf("Error getting log analytics workspace: %v", err)
	}

	linkedStorageAccounts, err := linkedStorageAccountsClient.Get(context.Background(), resourceGroupName, workspaceName, datasourceType, nil)
	if err != nil {
		t.Fatalf("Error getting linked storage accounts: %v", err)
	}

	t.Run("doesLogAnalyticsWorkspaceExist", func(t *testing.T) {
		assert.Equal(t, workspaceId, *workspace.ID, "Expected workspace ID to be %s, but got %s", workspaceId, *workspace.ID)
	})

	t.Run("isStorageAccountLinked", func(t *testing.T) {
		assert.Equal(t, 1, len(linkedStorageAccounts.Properties.StorageAccountIDs), "Expected 1 storage account to be linked, but got %d", len(linkedStorageAccounts.Properties.StorageAccountIDs))
		assert.Equal(t, storageAccountId, *linkedStorageAccounts.Properties.StorageAccountIDs[0], "Expected storage account ID to be %s, but got %s", storageAccountId, *linkedStorageAccounts.Properties.StorageAccountIDs[0])
	})
}
