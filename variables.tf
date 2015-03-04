
# AWS Account configuration
variable "access_key" {}
variable "secret_key" {}
variable "region" {
    default = "eu-west-1"
}

# Application / Web configuration
variable "web_ami" {
  description = "Image to use for company news webserver"
  default = {
    eu-west-1 = "ami-234ecc54"
    eu-central-1 = "ami-9a380b87"
  }
}

variable "web_instance_type" {
  description = "Instance type for company news webserver"
  default = "t2.micro"
}

variable "web_min_instances" {
  description = "Min instances for the web autoscaling group"
  default = 1
}

variable "web_max_instances" {
  description = "Max instances for the web autoscaling group"
  default = 2
}


variable "web_key_name" {
  description = "Name of the SSH keypair to use in AWS."
  default = ""
}
