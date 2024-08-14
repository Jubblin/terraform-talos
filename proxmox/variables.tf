
variable "proxmox_host" {
  description = "Proxmox host"
  type        = string
  default     = "192.168.1.1"
}

variable "proxmox_domain" {
  description = "Proxmox domain name"
  type        = string
  default     = "proxmox.local"
}

variable "proxmox_image" {
  description = "Proxmox source image name"
  type        = string
  default     = "talos"
}

variable "region" {
  description = "Proxmox Cluster Name"
  type        = string
  default     = "region-1"
}

variable "network_shift" {
  description = "Network number shift"
  type        = number
  default     = 8
}

variable "vpc_main_cidr" {
  description = "Local proxmox subnet"
  type        = list(string)
  default     = ["172.16.0.0/24", "fd60:172:16::/64"]
}

variable "release" {
  type        = string
  description = "The version of the Talos image"
  default     = "1.8.0"
}

data "sops_file" "tfvars" {
  source_file = "terraform.tfvars.sops.json"
}

data "terraform_remote_state" "init" {
  backend = "local"
  config = {
    path = "${path.module}/init/terraform.tfstate"
  }
}

locals {
  kubernetes = jsondecode(data.sops_file.tfvars.raw)["kubernetes"]

  proxmox_token = data.terraform_remote_state.init.outputs.ccm
}

variable "nodes" {
  description = "Proxmox nodes properties"
  type        = map(any)
  default = {
    "hvm-1" = {
      storage = "data",
      cpu     = ["0-3,16-19", "4-7,20-23", "8-11,24-27", "12-15,28-31"],
      ip4     = "1.1.0.1"
      ip6     = "2001:1:2:1::/64",
      gw6     = "2001:1:2:1::64",
    },
    "hvm-2" = {
      storage = "data",
      cpu     = ["0-3,16-19", "4-7,20-23", "8-11,24-27", "12-15,28-31"],
      ip4     = "1.1.0.2"
      ip6     = "2001:1:2:2::/64",
      gw6     = "2001:1:2:2::64",
    },
  }
}

variable "controlplane" {
  description = "Property of controlplane"
  type        = map(any)
  default = {
    "hvm-1" = {
      id    = 10010
      count = 0,
      cpu   = 4,
      mem   = 6144,
    },
  }
}

variable "instances" {
  description = "Map of VMs launched on proxmox hosts"
  type        = map(any)
  default = {
    "all" = {
      version = "v1.31.0"
    },
    "hvm-1" = {
      enabled         = false,
      web_id          = 11020,
      web_count       = 0,
      web_cpu         = 8,
      web_mem         = 27648,
      web_template    = "worker-sriov.yaml.tpl"
      web_labels      = ""
      web_sg          = "kubernetes"
      worker_id       = 11030,
      worker_count    = 0,
      worker_cpu      = 8,
      worker_mem      = 28672,
      worker_template = "worker-sriov.yaml.tpl"
      worker_sg       = "kubernetes"
      db_id           = 11030
      db_count        = 0,
      db_cpu          = 8,
      db_mem          = 28672,
      db_template     = "worker-sriov.yaml.tpl"
      db_labels       = ""
      db_sg           = "kubernetes"
    },
    "hvm-2" = {
      enabled         = false,
      web_id          = 12020,
      web_count       = 0,
      web_cpu         = 8,
      web_mem         = 27648,
      web_template    = "worker-sriov.yaml.tpl"
      web_labels      = ""
      web_sg          = "kubernetes"
      worker_id       = 12030,
      worker_count    = 0,
      worker_cpu      = 8,
      worker_mem      = 28672,
      worker_template = "worker-sriov.yaml.tpl"
      worker_sg       = "kubernetes"
      db_id           = 12040
      db_count        = 0,
      db_cpu          = 8,
      db_mem          = 28672,
      db_template     = "worker-sriov.yaml.tpl"
      db_labels       = ""
      db_sg           = "kubernetes"
    },
  }
}

variable "security_groups" {
  description = "Map of security groups"
  type        = map(any)
  default = {
    "controlplane" = "kubernetes"
    "web"          = "kubernetes"
    "worker"       = "kubernetes"
    "db"           = "kubernetes"
  }
}
