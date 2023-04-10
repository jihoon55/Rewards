variable "public_subnet_cidrs" {
  type        = list(string)
  default     = ["10.11.0.0/20","10.11.16.0/20"]
  description = "Public Subnet CIDR values"
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.11.128.0/20","10.11.144.0/20"]
}

variable "azs" {
    type = list(string)
    default = ["ap-northeast-2a", "ap-northeast-2b"]
    description = "Availability Zones"
}

variable "gateway_endpoint" {
    type = list(string)
    default = ["dynamodb","s3"]
}

variable "interface_endpoint" {
    type = list(string)
    default = ["ecr.dkr", "ecr.api", "logs", "sqs"]
}