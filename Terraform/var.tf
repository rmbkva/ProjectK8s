# Define variables

variable "region" {
  type = string 
  description = "Provided region"
}

variable vpc_cidr {
  type = list(object ({
    cidr_block = string 
    enable_dns_hostnames = bool 
    enable_dns_support = bool 
  }))
  description = "Provided vpc cidr"
}

variable subnet_cidr {
  type = list(object({
    cidr = string 
    sub_name = string 
  }))
  description = "Provided sub cidr and sub name"
}
  
variable "cluster_name" {
  type = string 
  description = "Provided cluster name "
}

variable "subnet_ids" {
  description = "List of subnet IDs where EKS nodes will be deployed"
  type        = list(string)
  default     = [] # You can set a default value here
}

variable "security_group_ids" {
  description = "List of security group IDs for the EKS cluster"
  type        = list(string)
  default     = []# You can set a default value here
}

variable ports {
    type = list(number)
    default = [22, 80]
}

variable "worker1_ip" {
  type = string
  default     = ""  # You can set a default value here
}

variable "worker2_ip" {
  type = string
  default     = "" # You can set a default value here
}

variable "master_ip" {
  type = string
  default     = "" # You can set a default value here
}