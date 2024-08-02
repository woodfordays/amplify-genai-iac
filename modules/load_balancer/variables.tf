variable "alb_name" {
  description = "The name of the ALB"
  default     = "my-alb"
}

variable "domain_name" {
  description = ""
  type        = string
}

variable "root_redirect" {
  description = "Whether to create an extra load balancer rule for root of domain. (e.g. vanderbilt.ai -> www.vanderbilt.ai)"
  type        = bool
  default     = false
}


variable "target_group_name" {
  description = "The name of the target group for the production environment"
  default     = "gen-ai-tg"
}

variable "target_group_port" {
  description = "The port of the target group"
  type        = string  
  default     = 3000
}

variable "alb_security_group_name" {
  description = "The name of the security group for the ALB"
  default     = "gen-ai-alb-sg"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
}

variable "alb_logging_bucket_name" {
  description = "ALB Logging Bucket Name"
  type        = string
}

variable "region" {
  description = "The AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
  default     = "main-vpc"
}

variable "private_key_path" {
  description = "Path to the private key file for the SSL certificate"
  type        = string
}

variable "certificate_body_path" {
  description = "Path to the certificate body file for the SSL certificate"
  type        = string
}

variable "certificate_chain_path" {
  description = "Path to the certificate chain file for the SSL certificate"
  type        = string
}