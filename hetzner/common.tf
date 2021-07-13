
data "hcloud_image" "talos" {
  with_selector = "type=infra"
}

resource "hcloud_ssh_key" "infra" {
  name       = "infra"
  public_key = file("~/.ssh/terraform.pub")
  labels     = merge(var.tags, { type = "infra" })
}

# resource "talos_cluster_config" "talos_config" {
#   cluster_name = var.cluster_name
#   endpoint     = "https://${hcloud_load_balancer.api.ip}:6443"
# }
