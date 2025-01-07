locals {
  tags = merge(var.tags, { provisioner = "Terraform" })
}
