
variable "region" {
  description = "Region"
  type        = string
}

variable "network_internal" {
  description = "Internal network"
}

variable "network_external" {
  description = "External network"
}

variable "instance_count" {
  description = "Instances in region"
  type        = number
}

variable "instance_flavor" {
  description = "Instance type"
  type        = string
}

variable "instance_image" {
  description = "Instance image"
  type        = string
}

variable "instance_params" {
  description = "Instance template parameters"
  type        = map(string)
}

variable "instance_ip_start" {
  description = "Instances in region"
  type        = number
  default     = 11
}