terraform {
    required_version = ">= 0.12"
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
  
}

provider "aws" {
    region = "ap-northeast-2"
}

resource "aws_vpc" "main" {
    cidr_block = "10.11.0.0/16"
}

resource "aws_subnet" "public_subnets" {
    count               = length(var.public_subnet_cidrs)
    vpc_id              = aws_vpc.main.id
    cidr_block          = element(var.public_subnet_cidrs, count.index)
    availability_zone   = element(var.azs, count.index)
 
    tags = {
        Name = "Public Subnet ${count.index + 1}"
    }
}
 
resource "aws_subnet" "private_subnets" {
    count               = length(var.private_subnet_cidrs)
    vpc_id              = aws_vpc.main.id
    cidr_block          = element(var.private_subnet_cidrs, count.index)
    availability_zone   = element(var.azs, count.index)
 
    tags = {
        Name = "Private Subnet ${count.index + 1}"
    }
}

resource "aws_internet_gateway" "gw" {
    vpc_id = aws_vpc.main.id
    
    tags = {
        Name = "Project VPC IG"
    }
}

resource "aws_route_table" "public_rt" {
    vpc_id = aws_vpc.main.id
    
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.gw.id
    }
    
    tags = {
        Name = "Public subnets Route Table"
    }
}

resource "aws_route_table_association" "public_subnet_asso" {
 count          = length(var.public_subnet_cidrs)
 subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
 route_table_id = aws_route_table.public_rt.id
}


resource "aws_vpc_endpoint" "gateway_endpoints" {
    count = length(var.gateway_endpoint)
    vpc_id       = aws_vpc.main.id
    service_name = "com.amazonaws.ap-northeast-2.${element(var.gateway_endpoint, count.index)}"

    tags = {
        Environment = "test"
        Name = " ${element(var.gateway_endpoint, count.index)} endpoint"
    }
}

resource "aws_vpc_endpoint" "interface_endpoints" {
    count = length(var.interface_endpoint)
    vpc_id       = aws_vpc.main.id
    service_name = "com.amazonaws.ap-northeast-2.${element(var.interface_endpoint, count.index)}"
    vpc_endpoint_type = "Interface"

    tags = {
        Environment = "test"
        Name = " ${element(var.interface_endpoint, count.index)} endpoint"
    }
}

resource "aws_ecr_repository" "userapi_image_repo" {
    name = "userapi-server"

}  

resource "aws_ecs_cluster" "userapi_cluster" {
    name = "userapi-cluster"
}
