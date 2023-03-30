variable "region" {
  type    = string
  default = "us-west-2"
}

variable "cluster_name" {
  type    = string
  default = "eks-cluster-1"
}

variable "namespace" {
  type    = string
  default = "amazon-cloudwatch"
}

variable "service_account" {
  type    = string
  default = "fluent-bit-sa"
}
