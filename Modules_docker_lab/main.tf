# VPC Module
module "vpc" {
  source = "./modules/vpc"
  vpc_name = var.vpc_name
  vpc_cidr = var.vpc_cidr
  azs = var.azs
  private_subnets = var.private_subnets
  public_subnets = var.public_subnets
}

# Security Group Module
module "security_group" {
  source = "./modules/security_group"
  sg_name = var.sg_name
  vpc_id = module.vpc.vpc_id
  ingress_rules = var.ingress_rules
# EC2 Instance Module
module "ec2_instance" {
  source = "./modules/ec2"

  instance_type   = "t2.medium"
  instance_type = var.instance_type
  ami_id = var.ami_id
  security_group_ids = [module.security_group.security_group_id]
  key_name = var.key_name
  user_data_script = var.user_data_script
  region = var.aws_region

}
# CloudTrail Module
module "cloudtrail" {
  source = "./modules/cloudtrail"
  cloudtrail_name = var.cloudtrail_name
  s3_bucket_name = var.cloudtrail_s3_bucket_name
  kms_key_deletion_window = var.cloudtrail_kms_key_deletion_window
  log_group_name = var.cloudtrail_log_group_name
  # ... other configurations

  provisioner "remote-exec" {
    inline = [
provider "aws" {
  region = var.aws_region
}
- hosts: all
  become: yes

  tasks:
    - name: Install Docker
      apt:
        name: docker.io
        state: present
