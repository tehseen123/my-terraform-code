#variables for VPC
variable "vpc-tags" {
  type = "map"
  default = {
    Name = "Tenzz-VPC"
  }
}

variable "vpc-cidr" {
  default = "10.0.0.0/16"
}

variable "tenancy" {
  default = "default"
}
########################################################################
# variables for public subnet

variable "public-subnet-cidr" {
  type    = "list"
  default = ["10.0.30.0/24", "10.0.33.0/24", "10.0.35.0/24", "10.0.37.0/24", "10.0.38.0/24", "10.0.40.0/24"]
}


# variables for private subnet

variable "pri-subnet-cidr" {
  type    = "list"
  default = ["10.0.80.0/24", "10.0.82.0/24"]
}
