variable "tenant_id" {}
variable "subscription_id" {}
#variable "client_id" {}
#variable "client_secret" {}


variable "resource_group" {
  type = string
  default = "demoapp_rg"
}

variable "location" {
  type = string
  default = "east US"
}


#K8s
variable "agent_count" {
  default = 1
}

variable "ssh_public_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "dns_prefix" {
  default = "demoapp"
}

variable cluster_name {
  default = "demoapp"
}

variable "kubernetes-version" {
  type = string
  default = "1.18.17"
}

variable "aks-prefix" {
  type = string
  default = "demoapp"
}

variable "aks-agents-az" {
  type = list(number)
  default = ["1", "2"]
}

variable "system_nodepool_nodes_count" {
  type = number
  default = 1
}

variable "system_nodepool_vm_size" {
  type = string
  default = "Standard_D2_v2"
}

variable "acr_name" {
  type = string
  default = "demoappac2registry"
}

#variable "keyvault_name" {
#  type = string
#  default = "demoappkv"
#}

variable "managed_identity_name" {
  type = string
  default = "demoappmiv1"
}


#Network

variable "vnet-name" {
  type = string
  default = "demoapp-vnet"
}

variable "vnet-address" {
  type = string
  default = "10.5.0.0/22"
}

variable "aks-subnet-name" {
  type = string
  default = "demoapp-subnet"
}

variable "aks-subnet-address" {
  type = string
  default = "10.5.0.0/24"
}

variable "tags" {
  type = map
  default = {
    environment = "dev"
    app      = "demoapp"
  }
}

#EP
variable "private-ep-subnet-address" {
  type = string
  default = "10.5.1.0/28"
}

variable "az-fw-subnet-address" {
  type = string
  default = "10.5.2.0/26"
}

variable "pip_name" {
  type = string
  default = "demoappv1-pip"
}

variable "fw_name" {
  type = string
  default = "demoappv1-fw"
}

variable "rt_name" {
  type = string
  default = "demoappv1-route-table"
}

variable "log_analytics_workspace_sku" {
  description = "The SKU (pricing level) of the Log Analytics workspace. For new subscriptions the SKU should be set to PerGB2018"
  type        = string
  default     = "PerGB2018"
}

variable "log_retention_in_days" {
  description = "The retention period for the logs in days"
  type        = number
  default     = 30
}
