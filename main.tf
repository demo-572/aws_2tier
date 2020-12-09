#AWS Provider Creation
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#AWS IAM Role Creation
resource "aws_iam_role" "aws-iam-role-demo" {
  name = "iam-demo-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
    tag-key = "tag-value"
  }
}

#AWS APP VPC
resource "aws_vpc" "app-vpc-demo" {
  cidr_block           = var.app_vpc_cidr
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "App-VPC-Demo"
  }
}

#AWS DB VPC
resource "aws_vpc" "db-vpc-demo" {
  cidr_block           = var.db_vpc_cidr
  enable_dns_hostnames = false
  enable_dns_support   = true
  instance_tenancy     = "default"

  tags = {
    Name = "DB-VPC-Demo"
  }
}

#AWS App Subnet1
resource "aws_subnet" "app-subnet1-demo" {
  vpc_id                  = aws_vpc.app-vpc-demo.id
  cidr_block              = var.app_sub1_cidr
  availability_zone       = var.az1a
  map_public_ip_on_launch = false

  tags = {
    Name = "App-Subnet1-Demo"
  }
}

#AWS App Subnet2
resource "aws_subnet" "app-subnet2-demo" {
  vpc_id                  = aws_vpc.app-vpc-demo.id
  cidr_block              = var.app_sub2_cidr
  availability_zone       = var.az1c
  map_public_ip_on_launch = false

  tags = {
    Name = "App-Subnet2-Demo"
  }
}


#AWS DB Subnet1
resource "aws_subnet" "db-subnet1-demo" {
  vpc_id                  = aws_vpc.db-vpc-demo.id
  cidr_block              = var.db_sub1_cidr
  availability_zone       = var.az1a
  map_public_ip_on_launch = false

  tags = {
    Name = "DB-Subnet1-Demo"
  }
}

#AWS DB Subnet2
resource "aws_subnet" "db-subnet2-demo" {
  vpc_id                  = aws_vpc.db-vpc-demo.id
  cidr_block              = var.db_sub2_cidr
  availability_zone       = var.az1c
  map_public_ip_on_launch = false

  tags = {
    Name = "DB-Subnet-Demo"
  }
}

#AWS Route Table for App
resource "aws_route_table" "app-rt-tbl" {
  vpc_id = aws_vpc.app-vpc-demo.id

  route {
    cidr_block = var.all_cidrs
    gateway_id = aws_internet_gateway.app-igw-demo.id
  }
  tags = {
    Name = "App-Route_Table"

  }

}

#AWS Route Table for DB
resource "aws_route_table" "db-rt-tbl" {
  vpc_id = aws_vpc.db-vpc-demo.id

  route {
    cidr_block = var.all_cidrs
    gateway_id = aws_internet_gateway.db-igw-demo.id
  }

  tags = {
    Name = "DB-Route_Table"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "app-igw-demo" {
  vpc_id = aws_vpc.app-vpc-demo.id

  tags = {
    Name = "app-igw-demo"
  }
}

#AWS Internet Gateway
resource "aws_internet_gateway" "db-igw-demo" {
  vpc_id = aws_vpc.db-vpc-demo.id

  tags = {
    Name = "db-igw-demo"
  }
}

#AWS VPC Peering Connection Requester
resource "aws_vpc_peering_connection" "vpc-peer-req" {
  peer_vpc_id = aws_vpc.db-vpc-demo.id
  vpc_id      = aws_vpc.app-vpc-demo.id
  auto_accept = true

  tags = {
    Side = "Requester"
  }

}

#AWS VPC Peering Connection Accepter
resource "aws_vpc_peering_connection_accepter" "vpc-peer-accpt" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-req.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}

#AWS Route for accepter
resource "aws_route" "db-sub1-rt" {
  route_table_id            = aws_route_table.db-rt-tbl.id
  destination_cidr_block    = var.app_sub1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-req.id
  depends_on                = [aws_route_table.db-rt-tbl]
}

resource "aws_route" "db-sub2-rt" {
  route_table_id            = aws_route_table.db-rt-tbl.id
  destination_cidr_block    = var.app_sub2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-req.id
  depends_on                = [aws_route_table.db-rt-tbl]
}

#AWS Route for Requester1
resource "aws_route" "app-sub1-rt" {
  route_table_id            = aws_route_table.app-rt-tbl.id
  destination_cidr_block    = var.db_sub1_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-req.id
  depends_on                = [aws_route_table.app-rt-tbl]
}

#AWS Route for Requester2
resource "aws_route" "app-sub2-rt" {
  route_table_id            = aws_route_table.app-rt-tbl.id
  destination_cidr_block    = var.db_sub2_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peer-req.id
  depends_on                = [aws_route_table.app-rt-tbl]
}

#Associate App subnet1 with route table
resource "aws_route_table_association" "app-sub1-rtbl-asst" {
  subnet_id      = aws_subnet.app-subnet1-demo.id
  route_table_id = aws_route_table.app-rt-tbl.id
}

#Associate App subnet2 with route table
resource "aws_route_table_association" "app-sub2-rtbl-asst" {
  subnet_id      = aws_subnet.app-subnet2-demo.id
  route_table_id = aws_route_table.app-rt-tbl.id
}

#Associate DB subnet1 with route table
resource "aws_route_table_association" "db-sub1-rtbl-asst" {
  subnet_id      = aws_subnet.db-subnet1-demo.id
  route_table_id = aws_route_table.db-rt-tbl.id
}

#Associate DB subnet2 with route table
resource "aws_route_table_association" "db-sub2-rtbl-asst" {
  subnet_id      = aws_subnet.db-subnet2-demo.id
  route_table_id = aws_route_table.db-rt-tbl.id
}


#AWS App Security Group
resource "aws_security_group" "app-sg-demo" {
  name        = "app-sg-demo"
  description = "App SG Demo"
  vpc_id      = aws_vpc.app-vpc-demo.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = var.tcp_protocal
    cidr_blocks = [var.all_cidrs]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = var.tcp_protocal
    cidr_blocks = [var.all_cidrs]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidrs]
  }
  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = var.tcp_protocal
    cidr_blocks = [var.all_cidrs]
  }

}

#AWS DB Security Group
resource "aws_security_group" "db-sg-demo" {
  name        = "db-sg-demo"
  description = "DB SG Demo"
  vpc_id      = aws_vpc.db-vpc-demo.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = var.tcp_protocal
    cidr_blocks = [var.app_vpc_cidr, var.db_vpc_cidr]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = var.tcp_protocal
    cidr_blocks = [var.app_vpc_cidr, var.db_vpc_cidr]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_cidrs]
  }
}

#AWS Load Balancer
resource "aws_lb" "aws-lb-demo" {
  name               = "aws-lb-demo"
  internal           = var.internal
  load_balancer_type = var.lb_type
  security_groups    = [aws_security_group.app-sg-demo.id]
  subnets            = [aws_subnet.app-subnet1-demo.id, aws_subnet.app-subnet2-demo.id]

  enable_deletion_protection = var.enable_delt_protect

  tags = {
    Environment = "demo"
  }
}

#AWS LB Listner
resource "aws_lb_listener" "aws-lb-lsnr" {
  load_balancer_arn = aws_lb.aws-lb-demo.arn
  port              = "80"
  protocol          = var.http_protocal

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "200"
    }
  }
}

#AWS LB Listner Rule
resource "aws_lb_listener_rule" "aws-lb-lsnr-rl" {
  listener_arn = aws_lb_listener.aws-lb-lsnr.arn

  action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "HEALTHY"
      status_code  = "200"
    }
  }

  condition {
    query_string {
      key   = "health"
      value = "check"
    }

    query_string {
      value = "bar"
    }
  }
}

#AWS LB Target Group
resource "aws_lb_target_group" "aws-lb-tg" {
  name     = "tf-example-lb-tg"
  port     = 80
  protocol = var.http_protocal
  vpc_id   = aws_vpc.app-vpc-demo.id

  tags = {
    Name = "aws-lb-target-gp"
  }
}

#AWS AutoScaling Group
resource "aws_autoscaling_group" "aws-asg-demo" {
  desired_capacity          = var.asg_desired
  health_check_grace_period = var.health_chk_grace_period
  health_check_type         = var.health_chk_type
  launch_configuration      = aws_launch_configuration.aws-lc-demo.id
  max_size                  = var.asg_max_size
  min_size                  = var.asg_min_size
  name                      = "aws-asg-demo"
  vpc_zone_identifier       = [aws_subnet.app-subnet1-demo.id, aws_subnet.app-subnet2-demo.id]

  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }


  tag {
    key                 = "Name"
    value               = "AWS-ASG-Demo"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_attachment" "aws-asg-atch" {
  autoscaling_group_name = aws_autoscaling_group.aws-asg-demo.id
  alb_target_group_arn   = aws_lb_target_group.aws-lb-tg.id
}

data "template_file" "user_data" {
  template = "${file("userdata.sh")}"
}

#AWS Launch Configuration
resource "aws_launch_configuration" "aws-lc-demo" {
  name                        = "aws-lc-demo"
  image_id                    = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.ssh_key
  security_groups             = [aws_security_group.app-sg-demo.id]
  enable_monitoring           = var.enable_monitoring
  ebs_optimized               = var.ebs_optimized
  associate_public_ip_address = var.associate_public_ip_address
  placement_tenancy           = var.instance_tenancy
  user_data                   = data.template_file.user_data.template


  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = true
  }

}

#AWS RDS Creation
resource "aws_db_instance" "mydb-demo" {
  identifier              = var.identifier
  allocated_storage       = var.volume_size
  storage_type            = var.volume_type
  engine                  = var.engine
  engine_version          = var.engine_version
  instance_class          = var.instance_class
  name                    = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  publicly_accessible     = var.publicly_accessible
  availability_zone       = var.az1c
  security_group_names    = []
  vpc_security_group_ids  = [aws_security_group.db-sg-demo.id]
  db_subnet_group_name    = aws_db_subnet_group.db-subnet-grp.name
  multi_az                = var.multi_az
  backup_retention_period = var.backup_retention_period
  backup_window           = var.backup_window
  #maintenance_window        = "thu:13:21-thu:13:51"
  #final_snapshot_identifier = "mydb-demo-final"
}

resource "aws_db_subnet_group" "db-subnet-grp" {
  name       = "rds-db-subnet"
  subnet_ids = [aws_subnet.db-subnet1-demo.id, aws_subnet.db-subnet2-demo.id]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_instance" "aws-db-instance" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = "PG-Bouncer"
  }
  count                       = 1
  subnet_id                   = aws_subnet.db-subnet1-demo.id
  key_name                    = var.ssh_key
  vpc_security_group_ids      = [aws_security_group.db-sg-demo.id]
  associate_public_ip_address = var.associate_public_ip_address

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    delete_on_termination = var.delete_on_termination
  }

}
