variable "region" {
  default     = "us-west-1"
  description = "AWS Region"
}

variable "access_key" {
  description = "AWS Access Key"
  default     = ""
}

variable "secret_key" {
  description = "AWS Secret Key"
  default     = ""
}

variable "instance_type" {
  default     = "t2.micro"
  description = "AWS instance type"
}

variable "instance_tenancy" {
  default     = "default"
  description = "Instance Tenancy"
}

variable "app_vpc_cidr" {
  default     = "10.100.0.0/16"
  description = "VPC cidr block"
}

variable "db_vpc_cidr" {
  default     = "10.200.0.0/16"
  description = "VPC cidr block"
}

variable "az1a" {
  default     = "us-west-1a"
  description = "AWS Availability zone"
}

variable "az1c" {
  default     = "us-west-1c"
  description = "AWS Availability zone"
}


variable "app_sub1_cidr" {
  default     = "10.100.1.0/24"
  description = "Subnet CIDR Block"
}

variable "app_sub2_cidr" {
  default     = "10.100.2.0/24"
  description = "Subnet CIDR Block"
}

variable "db_sub1_cidr" {
  default     = "10.200.1.0/24"
  description = "Subnet CIDR Block"
}

variable "db_sub2_cidr" {
  default     = "10.200.2.0/24"
  description = "Subnet CIDR Block"
}

variable "all_cidrs" {
  default     = "0.0.0.0/0"
  description = "Destination CIDR Block"
}

variable "tcp_protocal" {
  default     = "tcp"
  description = "TCP Protocal"
}

variable "http_protocal" {
  default     = "HTTP"
  description = "HTTP Protocal"
}

variable "ssh_key" {
  default     = "demo-key"
  description = "AWS Key Name"
}

variable "lb_type" {
  default     = "application"
  description = "LB Type"
}

variable "internal" {
  default     = "false"
  description = "Load Balancer internal"
}

variable "enable_delt_protect" {
  default     = "false"
  description = "Enable Delete protection"
}

variable "volume_size" {
  default     = "10"
  description = "AWS EBS Volume Size"
}

variable "volume_type" {
  default     = "gp2"
  description = "Volume Type"
}

variable "ami_id" {
  default     = "ami-00831fc7c1e3ddc60"
  description = "AWS AMI ID"
}

variable "delete_on_termination" {
  default     = "true"
  description = "delete on termination"
}

variable "asg_max_size" {
  default     = "3"
  description = "ASG Max Size"
}

variable "asg_min_size" {
  default     = "2"
  description = "ASG Min Size"
}

variable "asg_desired" {
  default     = "2"
  description = "ASG Desired Capacity"
}

variable "health_chk_grace_period" {
  default     = "300"
  description = "ASG Health Check Grace Period"
}

variable "health_chk_type" {
  default     = "EC2"
  description = "ASG Health Check Type"
}

variable "enable_monitoring" {
  default     = "false"
  description = "Enable monitoring"
}

variable "ebs_optimized" {
  default     = "false"
  description = "EBS Optimised"
}

variable "associate_public_ip_address" {
  default     = "true"
  description = "ASG Health Check Type"
}

variable "identifier" {
  default     = "mydb-demo"
  description = "Identifier for your DB"
}

variable "engine" {
  default     = "postgres"
  description = "Engine type, example values mysql, postgres"
}

variable "engine_version" {
  description = "Engine version"
  default = "12.4"
}

variable "instance_class" {
  default     = "db.t2.micro"
  description = "Instance class"
}

variable "db_name" {
  default     = "mydb"
  description = "Database Name"
}

variable "db_username" {
  default     = "usernameVariable"
  description = "DB User name"
}

variable "db_password" {
  default     = "passwordVariable"
  description = "password, provide through your ENV variables"
}

variable "db_port" {
  default     = "5432"
  description = "DB Port No"
}

variable "publicly_accessible" {
  default     = "false"
  description = "publicly accessible"
}

variable "multi_az" {
  default     = "false"
  description = "multi az"
}

variable "backup_retention_period" {
  default     = "7"
  description = "backup retention period"
}

variable "backup_window" {
  default     = "07:42-08:12"
  description = "backup window"
}

variable "db_pg_name" {
  default     = "rds-pg"
  description = "DB Parameter Group Name"
}

variable "db_subnet_grp_name" {
  default     = "db-sub-gp"
  description = "DB Subnet group Name"
}
