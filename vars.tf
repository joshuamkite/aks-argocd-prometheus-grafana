variable "agents_count" {
  description = "Number of agent VMs"
  type        = number
  default     = 1
}

variable "agents_max_count" {
  description = "Maximum number of agent VMs"
  type        = number
  default     = 2
}

variable "agents_min_count" {
  description = "Minimum number of agent VMs"
  type        = number
  default     = 1
}

variable "agents_pool_name" {
  description = "Name of the agent pool"
  type        = string
  default     = "nodepool"
}

variable "agents_size" {
  description = "Size of the agent VMs"
  type        = string
  default     = "Standard_B2s"
}

variable "enable_auto_scaling" {
  description = "Enable auto-scaling for the agent pool"
  type        = bool
  default     = true
}

variable "environment" {
  description = "The environment name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "name" {
  description = "Name to apply for all resources in the stack"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "rbac_aad" {
  description = "Enable RBAC AAD"
  type        = bool
  default     = false
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string

}
