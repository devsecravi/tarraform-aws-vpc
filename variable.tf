variable "project"{

    type = string
}

variable "environment" {

    typr = string
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

variable "subnet_public_tags"{
      type = map
      default = {}
}


