provider "alicloud"{
}

# Create a VPC
resource "alicloud_vpc" "vpc" {
  vpc_name    = "vpc-terraform"
  cidr_block  = "172.16.0.0/16"
}

resource "alicloud_vswitch" "vswitch" {
  vpc_id            = alicloud_vpc.vpc.id
  cidr_block        = "172.16.0.0/24"
  zone_id           = "ap-southeast-5a"
  vswitch_name      = "vswitch-a"
}

resource "alicloud_security_group" "group" {
  name        = "sg-terraform"
  description = "terraform"
  vpc_id      = alicloud_vpc.vpc.id
}

resource "alicloud_instance" "instance" {
  #indonesia
  #availability_zone   = "ap-southeast-5"
  security_groups      = alicloud_security_group.group.*.id
  instance_type        = "ecs.t6-c1m1.large"
  system_disk_category = "cloud_efficiency"
  image_id             = "ubuntu_20_04_x64_20G_alibase_20220215.vhd"
  instance_name        = "ecs-from-terraform"
  vswitch_id           = alicloud_vswitch.vswitch.id
  password             = "P@ssw0rd123#"
  instance_charge_type = "PostPaid"
}

resource "alicloud_db_instance" "rds" {
  engine               = "MySQL"
  engine_version       = "5.7"
  instance_type        = "mysql.n1.micro.1"
  instance_storage     = "20"
  instance_charge_type = "Postpaid"
  instance_name        = "rds-from-terraform"
  vswitch_id           = alicloud_vswitch.vswitch.id
}
