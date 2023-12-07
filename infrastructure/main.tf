//define resource to create your VPC
resource "aws_vpc" "gozem_business_case_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "gozem_business_case_vpc"
  }
}
//create public subnets
resource "aws_subnet" "gozem_public_subnet1" {
  vpc_id                  = aws_vpc.gozem_business_case_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "gozem_public_subnet1"
  }
}

resource "aws_subnet" "gozem_public_subnet2" {
  vpc_id                  = aws_vpc.gozem_business_case_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "gozem_public_subnet2"
  }
}
//create security group
resource "aws_security_group" "my_sg" {
  name        = "gozem-lb-security-group"
  description = "Security group for the Load Balancer"
  vpc_id      = aws_vpc.gozem_business_case_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
//create route table
resource "aws_route_table" "gozem_public_subnet1_rt" {
  vpc_id = aws_vpc.gozem_business_case_vpc.id
}

resource "aws_route_table" "gozem_public_subnet2_rt" {
  vpc_id = aws_vpc.gozem_business_case_vpc.id
}

resource "aws_route_table_association" "public_subnet1_association" {
  subnet_id      = aws_subnet.gozem_public_subnet1.id
  route_table_id = aws_route_table.gozem_public_subnet1_rt.id
}

resource "aws_route_table_association" "public_subnet2_association" {
  subnet_id      = aws_subnet.gozem_public_subnet2.id
  route_table_id = aws_route_table.gozem_public_subnet2_rt.id
}
resource "aws_internet_gateway" "gozem_internet_gateway" {
  vpc_id = aws_vpc.gozem_business_case_vpc.id
}
//create loadbalancer
resource "aws_lb" "gozem-my-lb" {
  name               = "gozem-my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.gozem_public_subnet1.id, aws_subnet.gozem_public_subnet2.id]
}

//create launch configuration
resource "aws_launch_configuration" "gozem_my_launch_config" {
  name = "gozem_my_launch_config"
  image_id = "ami-0230bd60aa48260c6"
  instance_type = "t2.micro"
  // Add other configurations as needed
  iam_instance_profile = "gozem-ec2-lauch-role"
}

resource "aws_autoscaling_group" "my_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = aws_launch_configuration.gozem_my_launch_config.id
  vpc_zone_identifier  = [aws_subnet.gozem_public_subnet1.id, aws_subnet.gozem_public_subnet2.id]

}
