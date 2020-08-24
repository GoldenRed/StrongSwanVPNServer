## Pre-created resources on AWS
variable "image_id" {
  default = "ami-08baf9e3c347b7092" #Ubuntu Server 20.04 LTS(HVM) <- AMI code specific for the eu-north-1 region.
}


variable "key_pair" {
  default = "SS_EC2_key"
}

## AWS settings

variable "region" {
  default = "eu-north-1"
}

variable "instance_type" {
  default = "t3.nano"
}

variable "ingress_ipv4_cidr_1"{
  default = ["0.0.0.0/0"]
}
variable "ingress_ipv6_cidr_1" {
  default = ["::/0"]
}

variable "ingress_ipv4_cidr_2"{
  ## ideally your private IP
  default = ["0.0.0.0/0"]
}



## Tagging and Identification

variable "base_prefix" {
  default = "StrongSwanVPN"
}