variable "project"{

    type = string
}

variable "environment" {

    type = string
}

variable "cidr_block"{
    type = string
    default = "10.0.0.0/16"
}

variable "vpc_tags"{
    type= map
    default={}
}

variable "gw_tags"{
     type = map
     default ={}
}

variable "subnet_public" {
    type = list
    default = ["10.0.1.0/24","10.0.2.0/24"]
}
variable "subnet_private" {
    type = list
    default = ["10.0.11.0/24","10.0.12.0/24"]
}

variable "subnet_database" {
    type = list
    default = ["10.0.21.0/24","10.0.22.0/24"]
}
variable "subnet_public_tags"{
      type = map
      default = {}
}

variable "subnet_private_tags"{
      type = map
      default = {}
}

variable "subnet_database_tags"{
      type = map
      default = {}
}

variable "aw_route_table_public" {
     type = map
     default = {}
}

variable "aw_route_table_private" {
     type = map
     default = {}
}

variable "aw_route_table_database" {
     type = map
     default = {}
}

variable "eip_nat_tags"{
      type = map
      default = {}
}

variable "nat_gateway_tags"{
      type = map
      default = {}
}

variable "is_peering" {
      type = bool
      default = false
}