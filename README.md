# AWS Native Observability for EKS

## Audience 
This terraform repo is for anyone who wants to capture `metrics` and `logs` from any EKS cluster by sending them to `Amazon CloudWatch Container Insights` and who is following the [documentation links](#links) to do so.

> **Note:** This repo is only meant to facilitate rapid AWS native observability deployment in lower environments such as dev and test, and inherently isn't production ready. Use it at your own discretion

## Usage 

### Prerequisites

Ensure that you have access to the EKS cluster as `admin` by running the following command

```sh
# Change the cluster-name and region before running the following command
aws eks update-kubeconfig --name eks-cluster-1 --region us-west-2
```

### Terraform Apply/Destroy

Follow the steps below to use this `terraform` repo for your EKS environment
1. Git clone the project and `cd` into the repo directory

   ```sh 
   git clone https://github.com/vchintal/aws-native-observability-for-eks.git 
   cd aws-native-observability-for-eks
   ```
2. Make a `terraform` variables file, let's say, `dev.tfvars` with the following content
   ```
   region          = "us-west-2" 
   cluster_name    = "eks-cluster-1" 
   namespace       = "native-observability" 
   service_account = "native-observability-sa" 
   ``` 
   * `region`: Region of your EKS Cluster
   * `cluster_name`: Name of your EKS cluster
   * `namespace`: Namespace in which k8s manifests are deployed to
   * `service_account`: Service Account which has the necessary privileges to write to CloudWatch logs
3. Apply the repo to your environment
   ```sh
   terraform apply -var-file=dev.tfvars  --auto-approve 
   ``` 
4. Destroy the deployed resources from your environment
   ```sh
   terraform destroy -var-file=dev.tfvars  --auto-approve 
   ``` 


## Links

* [Setting up Container Insights on Amazon EKS and Kubernetes](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/deploy-container-insights-EKS.html) 
  * [Verify prerequisites](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-prerequisites.html)
  * [Set up Fluent Bit as a DaemonSet to send logs to CloudWatch Logs](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-setup-logs-FluentBit.html)
  * [Using AWS Distro for OpenTelemetry](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Container-Insights-EKS-otel.html) _(for metrics)_