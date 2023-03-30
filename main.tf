provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.this.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.this.token
  }
}

provider "kubectl" {
  apply_retry_count      = 10
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  load_config_file       = false
  token                  = data.aws_eks_cluster_auth.this.token
}

data "aws_iam_openid_connect_provider" "this" {
  url = data.aws_eks_cluster.this.identity[0].oidc[0].issuer
}

data "aws_eks_cluster" "this" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "this" {
  name = var.cluster_name
}

module "irsa" {
  source                     = "github.com/aws-ia/terraform-aws-eks-blueprints//modules/irsa"
  eks_cluster_id             = var.cluster_name
  eks_oidc_provider_arn      = data.aws_iam_openid_connect_provider.this.arn
  kubernetes_namespace       = var.namespace
  kubernetes_service_account = var.service_account
  irsa_iam_policies          = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"]
}

resource "helm_release" "containerinsights-logs" {
  name       = "containerinsights-logs"
  repository = path.cwd
  chart      = "containerinsights-logs"

  values = [templatefile("${path.module}/containerinsights-values.yaml", {
    namespace      = var.namespace
    serviceAccount = var.service_account
    region         = var.region
    clusterName    = var.cluster_name
  })]
}

resource "helm_release" "containerinsights-metrics" {
  name       = "containerinsights-metrics"
  repository = path.cwd
  chart      = "containerinsights-metrics"

  values = [templatefile("${path.module}/containerinsights-values.yaml", {
    namespace      = var.namespace
    serviceAccount = var.service_account
    region         = var.region
    clusterName    = var.cluster_name
  })]
}