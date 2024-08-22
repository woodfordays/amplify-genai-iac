variable "vpc_id" {
  description = "ID of the VPC to attach to the Transit Gateway"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs to use for the Transit Gateway attachment"
  type        = list(string)
}

variable "transit_gateway_arn" {
  description = "ARN of the Transit Gateway to attach to"
  type        = string
}

variable "transit_gateway_route_table_id" {
  description = "ID of the Transit Gateway route table"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC (used for tagging)"
  type        = string
}
