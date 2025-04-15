variable "ami_id" {
  type        = string
  default     = "ami-084568db4383264d4"

}
variable "key_name" {
  default = "main"
}
variable "instance_type" {
  type        = string
  default     = "t2.micro"
}
variable "public_cidr_block" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "private_cidr_block" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "description"
}
variable availability_zone {
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}
