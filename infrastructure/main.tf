
// main.tf

provider "aws" {
  region = "your_region"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "my_vpc"
  }
}

resource "aws_subnet" "public_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block             = "10.0.1.0/24"
  availability_zone       = "your_az1"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet1"
  }
}

resource "aws_subnet" "public_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block             = "10.0.2.0/24"
  availability_zone       = "your_az2"
  map_public_ip_on_launch = true
  tags = {
    Name = "public_subnet2"
  }
}

resource "aws_subnet" "private_subnet1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block             = "10.0.3.0/24"
  availability_zone       = "your_az1"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet1"
  }
}

resource "aws_subnet" "private_subnet2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block             = "10.0.4.0/24"
  availability_zone       = "your_az2"
  map_public_ip_on_launch = false
  tags = {
    Name = "private_subnet2"
  }
}

// Add other necessary configurations for the VPC, such as Internet Gateway, Route Tables, etc.

resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.my_sg.id]
  subnets            = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

//resource "aws_security_group" "my_sg" {
  // Define security group rules as needed
//}

resource "aws_launch_configuration" "my_launch_config" {
  name = "my-launch-config"
  image_id = "your_ami"
  instance_type = "t2.micro"
  // Add other configurations as needed
}

resource "aws_autoscaling_group" "my_asg" {
  desired_capacity     = 2
  max_size             = 5
  min_size             = 1
  launch_configuration = aws_launch_configuration.my_launch_config.id
  vpc_zone_identifier  = [aws_subnet.public_subnet1.id, aws_subnet.public_subnet2.id]
}

