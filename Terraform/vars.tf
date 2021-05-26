variable "subscription_id" {
  type        = string
  default = "d869cbf8-8990-4e0b-94ca-9ec4e5ee2463"
  description = "Mention the Azure Subscription ID"
}

variable "client_id" {
  type        = string
  description = "2e4a533b-0e77-45f3-a33b-bcde627341f6"
}

variable "client_secret" {
  type        = string
  description = "1lShOuES7iGdYW-~ykF~D.tT7YeYATmvoK"
}

variable "tenant_id" {
  type        = string
  default = "19cf5455-841e-4591-9654-f8b08846a572"
  description = "Mention the Azure Tenant ID"
}


##############################
## Core Network - Variables ##
##############################

variable "network-vnet-cidr" {
  type        = string
  description = "The CIDR of the network VNET"
}

variable "network-subnet-cidr" {
  type        = string
  description = "The CIDR for the network subnet"
}
variable "vm-username" {
  type        = string
  description = "VM Admin User"
  default     = "<userName>"
}

# VM Admin Password
variable "vm-password" {
  type        = string
  description = "VM Admin Password"
  default     = "<password>"
}

# VM Hostname (limited to 15 characters long)
variable "virtual_network_name" {
  type        = string
  description = "VM Hostname"
  default     = "demoVM"
}

# Windows VM Virtual Machine Size
variable "vm-size" {
  type        = string
  description = "VM Size"
  default     = "Standard_B1ls"
}

# Project environment
variable "environment" {
  type        = string
  description = "This variable defines the environment to be built"
}
variable "application_type" {
  type        = string
  description = "application_type"
  default     = "CompleteCICDProj"
}
variable "address_prefix_test" {
  type        = string
  description = "address_prefix_test "
  default     = "10.5.1.0/24"
}

# azure region
variable "location" {
  type        = string
  description = "Azure region where the resource group will be created"
  default     = "East US"
}

####################
## Main Variables ##
####################

variable "resource_group" {
  description = "Name of the resource group, including the -rg"
  default     = "proj3-packerIMG"
  type        = string
}

variable "packer_resource_group" {
  description = "Mention the name of the resource group where the image is located"
  default     = "demo-rg"
  type        = string
}
variable "packer_image" {
  description = "packer_image"
  default     = "myPackerImage"
  type        = string
}
variable "public_key_path" {
  description = "public_key_path "
  default     = "/home/katy/.ssh/id_rsa.pub"
  type        = string
}
variable "admin_username" {
  description = "admin_username"
  default     = "admin"
  type        = string
}
variable "prefix" {
  description = "The prefix which should be used for all resources in the resource group specified"
  default     = "devops-proj3"
  type        = string
}
variable "address_space" {
  description = "address_space"
  default     = "10.5.0.0/16"
  type        = string
}

variable "num_of_vms" {
  description = "Number of VM resources to create behind the load balancer"
  default     = 1
  type        = number
}
