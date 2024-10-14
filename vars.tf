locals {
  description = "Resource created using terraform"
}

# --------------------------------------------------------
# This 'random_id_4' will make whatever you create (names, etc)
# unique in your account.
# --------------------------------------------------------
resource "random_id" "id" {
  byte_length = 4
}

# --------------------------
# AWS RDS (Oracle) variables
# --------------------------
variable "aws_rds_region" {
  description = "Amazon RDS (Oracle) region"
  type    = string
  default = "us-east-1"
}

variable "rds_instance_class" {
  description = "Amazon RDS (Oracle) instance size"
  type        = string
  default     = "db.m5.large"
}

variable "rds_instance_identifier" {
  description = "Amazon RDS (Oracle) instance identifier prefix"
  type        = string
  default     = "demo-db-mod"
}

variable "rds_username" {
  description = "Amazon RDS (Oracle) master username"
  type        = string
  default     = "admin"
}

variable "rds_password" {
  description = "Amazon RDS (Oracle) database password. You can change it through command line"
  type        = string
  default     = "db-mod-c0nflu3nt!"
}

variable "rds_vpc_cidr" {
  type        = string
  description = "VPC IPv4 CIDR"
  default     = "10.0.0.0/16"
}

variable "rds_subnet_1_cidr" {
  type        = string
  description = "IPv4 CIDR for RDS Oracle subnet 1"
  default     = "10.0.1.0/24"
}

variable "rds_subnet_2_cidr" {
  type        = string
  description = "IPv4 CIDR for RDS Oracle subnet 2"
  default     = "10.0.2.0/24"
}

# --------------------------
# MongoDB variables
# --------------------------
variable "cluster_name_mongodb" {
  type    = string
  default = "terraformFlinkDemo"
}

variable "database_mongodb" {
  type    = string
  default = "confluent_flink_demo"
}

variable "username_mongodb" {
  type    = string
  default = "mongodb-demo"
}

resource "random_password" "mongodb-password" {
  length           = 16
  special          = true
  override_special = "#$-_=+"
}

variable "provider_name_mongodb" {
  type    = string
  default = "TENANT"
}

variable "cloud_provider_mongodb" {
  type    = string
  default = "AWS"
}

variable "cloud_region_mongodb" {
  type    = string
  default = "US_EAST_1"
}

variable "provider_instance_size_name_mongodb" {
  type    = string
  default = "M0"
}

# ----------------------------------------
# Confluent Cloud Kafka cluster variables
# ----------------------------------------
variable "cc_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "cc_cloud_region" {
  type    = string
  default = "us-east-1"
}

variable "cc_env_name" {
  type    = string
  default = "demo"
}

variable "cc_cluster_name" {
  type    = string
  default = "demo_cluster"
}

variable "cc_availability" {
  type    = string
  default = "SINGLE_ZONE"
}

# ------------------------------------------
# Confluent Cloud Schema Registry variables
# ------------------------------------------
variable "sr_cloud_provider" {
  type    = string
  default = "AWS"
}

variable "sr_cloud_region" {
  type    = string
  default = "us-east-1"
}

variable "sr_package" {
  type    = string
  default = "ESSENTIALS"
}

# --------------------------------------------
# Confluent Cloud Flink Compute Pool variables
# --------------------------------------------
variable "cc_dislay_name" {
  type    = string
  default = "standard_compute_pool"
}

variable "cc_compute_pool_name" {
  type    = string
  default = "cc_demo_flink"
}

variable "cc_compute_pool_cfu" {
  type    = number
  default = 5
}
