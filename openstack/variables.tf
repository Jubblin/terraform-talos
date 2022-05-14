
data "terraform_remote_state" "prepare" {
  backend = "local"
  config = {
    path = "${path.module}/prepare/terraform.tfstate"
  }
}

locals {
  regions          = data.terraform_remote_state.prepare.outputs.regions
  network_external = data.terraform_remote_state.prepare.outputs.network_external

  network         = data.terraform_remote_state.prepare.outputs.network
  network_public  = data.terraform_remote_state.prepare.outputs.network_public
  network_private = data.terraform_remote_state.prepare.outputs.network_private
  network_subnets = { for zone in local.regions : zone => [local.network_public[zone].cidr, local.network_private[zone].cidr] }

  network_secgroup = data.terraform_remote_state.prepare.outputs.network_secgroup
}

variable "ccm_username" {
  default = ""
}

variable "ccm_password" {
  default = ""
}

variable "kubernetes" {
  type = map(string)
  default = {
    podSubnets     = "10.32.0.0/12,fd40:10:32::/102"
    serviceSubnets = "10.200.0.0/22,fd40:10:200::/112"
    domain         = "cluster.local"
    apiDomain      = "api.cluster.local"
    clusterName    = "talos-k8s-openstack"
    clusterID      = ""
    clusterSecret  = ""
    tokenMachine   = ""
    caMachine      = ""
    token          = ""
    ca             = ""
  }
  sensitive = true
}

variable "controlplane" {
  description = "Controlplane config"
  type        = map(any)
  default = {
    "GRA7" = {
      count         = 0,
      instance_type = "d2-2",
    },
    "GRA9" = {
      count         = 0,
      instance_type = "d2-2",
    },
  }
}

variable "instances" {
  description = "Map of region's properties"
  type        = map(any)
  default = {
    "REGION" = {
      web_count            = 0,
      web_instance_type    = "d2-2",
      worker_count         = 0,
      worker_instance_type = "d2-2",
    },
  }
}
