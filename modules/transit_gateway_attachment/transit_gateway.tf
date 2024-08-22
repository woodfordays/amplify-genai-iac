resource "aws_ec2_transit_gateway_vpc_attachment" "tgw_attachment" {
  subnet_ids         = aws_subnet.private[*].id
  transit_gateway_id = var.transit_gateway_arn
  vpc_id             = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-tgw-attachment"
  }
}

resource "aws_ec2_transit_gateway_route_table_association" "tgw_route_table_assoc" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.tgw_attachment.id
  transit_gateway_route_table_id = var.transit_gateway_route_table_id
}

resource "aws_route" "to_tgw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"  # Or your specific CIDR for other VPCs/networks
  transit_gateway_id     = var.transit_gateway_arn
}