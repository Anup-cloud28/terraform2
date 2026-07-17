# provider
provider "aws" {
    region = "us-east-1"  
}
# vpc
resource "aws_vpc" "TestVPC" {
    cidr_block = "10.0.0.0/24"
}
# internet gateway
resource "aws_internet_gateway" "TestInternetGateway" {
    vpc_id = aws_vpc.TestVPC.id
}
# public subnet
resource "aws_subnet" "TestPublicSubnet" {
    vpc_id = aws_vpc.TestVPC.id
    cidr_block = "10.0.0.28"
    map_public_ip_on_launch = true
}
# private subnet
resource "aws_subnet" "TestPrivateSubnet" {
    vpc_id = aws_vpc.TestVPC.id
    cidr_block = "10.0.0.32"
}

# public route table
resource "aws_route_table" "TestPublicRouteTable" {
    vpc_id = aws_vpc.TestVPC.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.TestInternetGateway.id
    }
}
# private route table
resource "aws_route_table" "TestPrivateRouteTable" {
    vpc_id = aws_vpc.TestVPC.id
}

#associate public route table with public subnet
resource "aws_route_table_association" "TestPublicRouteTableAssociation" {
    subnet_id = aws_subnet.TestPublicSubnet.id
    route_table_id = aws_route_table.TestPublicRouteTable.id
}
resource "aws_route_table_association" "TestPrivateRouteTableAssociation" {
    subnet_id = aws_subnet.TestPrivateSubnet.id
    route_table_id = aws_route_table.TestPrivateRouteTable.id
}