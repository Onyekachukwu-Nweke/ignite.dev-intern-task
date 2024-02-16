## Task instructions for DevOps Intern Role

### Setup a kubernetes cluster using kind 
1. Write a simple bash script that deploys a [kind](https://kind.sigs.k8s.io/docs/user/quick-start/)  cluster locally
2. Download the kubeconfig for the cluster and store in a safe place, we will use it much later in the next steps

### Deploy a sample Node.js app using terraform

1. When kind is up and running, dockerize a simple hello world [express](https://expressjs.com/en/starter/hello-world.html) and deploy to dockerhub
2. create a kubernetes deployment manifest to deploy the Node.js to the kind cluste but don't apply it yet
3. using the [kubectl terraform provider](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs), write a terraform code to deploy the kubectl manifest to the kind cluster 

### Bonus

1. Using the [kube-prometheus stack](https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/README.md), using [terraform helm provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs), setup monitoring and observability for the prometheus cluster.

### Submission

1. Create a repository with all your code in it
2. Send an email to intern.task@ignite.dev on or before 02/17/2024
   
## Task Submission By Nweke Onyekachukwu Ejiofor
This section of the README shows a step-by-step process on how to setup KinD locally using a bash script, dockerize a backend NodeJS application, and also use terraform to deploy the to the cluster and setup monitoring and observability using **kube-prometheus-stack**

### Table of Contents
- [Prerequisite](#prequisite)
- [Assumptions](#assumptions)
- [KinD Setup](#kind-setup)
- [Terraform Setup](#terraform-setup)
- [Terraform Configurations](#terraform-configurations)
- [Deploying Infrastructure]()
- [Cleanup]()
- [License]()

### Prerequisites
- Ensure you have Docker installed on your local machine.
- Have Kind (Kubernetes in Docker) installed. Refer to the [Kind documentation](https://kind.sigs.k8s.io/docs/user/quick-start/) for installation instructions.
- Install Terraform on your machine. Instructions can be found [here](https://learn.hashicorp.com/tutorials/terraform/install-cli).

### Assumptions
Based on the provided requirements, here are some technical assumptions that I made for the project:

- You have basic knowledge of Docker, Kubernetes, and Terraform.
- Your local machine meets the minimum requirements for running Docker and Kind.
- Host system is a local machine running linux VM (Ubuntu precisely).
- You have a Dockerhub account for pushing Docker images.

---

### KinD Setup:
1. Clone the task repository
2. Create a scripts folder
3. Execute the provided `setup_cluster.sh` bash script inside the scripts folder to create a Kind cluster with desired configurations such as checking if docker and kubectl is installed and the `kubeconfig` file stored elsewhere.

![Picture of Kind Cluster](/img/kind-dep.png)
![Picture of resources deployed](/img/kind-res.png)

---

### Terraform Setup:
1. Create a terraform folder and initialized it using the command below

```hcl
terraform init
```
- Initializes Terraform in the current directory, downloading necessary plugins and modules.



2. Create `main.tf` File:
  - Inside the `terraform` directory, create a file named `main.tf`.
  - This file contains the main Terraform code responsible for deploying resources to the cluster.
  
3. Create Templates Folder:
  - Inside the terraform directory, create a folder named templates.
  - This folder contains additional templates or configuration files needed for the Terraform deployment.

---

### Terraform Configurations:
This Terraform configuration manages Kubernetes resources and Helm releases using the `kubectl` and `helm` providers. It leverages Terraform version 0.13 or higher.

### Dependencies
- **Terraform Version:** 0.13 or higher
- **Terraform Providers:** 
  - `kubectl` provider from "gavinbunney/kubectl" source, version 1.7.0 or higher
  - `helm` provider for Helm chart management
  
### Configuration Details

#### Terraform Block
```hcl
terraform {
  required_version = ">= 0.13"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
```
- Sets the required Terraform version and specifies the required providers.

#### Providers
```hcl
provider "kubectl" {
  load_config_file = true
  config_path      = "~/.kube/config_kind"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config_kind"
  }
}
```
- Configures the `kubectl` provider to load the Kubernetes configuration file from `~/.kube/config_kind`.
- Configures the `helm` provider to interact with Kubernetes using the same configuration file.

#### Data Source
```hcl
data "kubectl_path_documents" "docs" {
    pattern = "./templates/*.yaml"
}
```
- Collects YAML documents from the specified directory pattern for further processing.

#### Resources
```hcl
resource "kubectl_manifest" "test" {
    for_each  = toset(data.kubectl_path_documents.docs.documents)
    yaml_body = each.value
}

resource "helm_release" "kube_prometheus_stack" {
  name              = "kube-prometheus-stack"
  create_namespace = true
  repository        = "https://prometheus-community.github.io/helm-charts"
  chart             = "kube-prometheus-stack"
  namespace         = "monitoring"
  values            = [ file("${path.module}/templates/values/values.yaml") ]
}
```
- Creates Kubernetes resources from YAML manifests for the `hello-world` app found in the specified directory.
- Deploys a Helm chart named "kube-prometheus-stack" from the specified repository into the "monitoring" namespace, using values defined in a separate file.

---

### Validate Infrastructure & Plan
Here's a README outline for validating infrastructure and creating an execution plan in Terraform:

---

### Validate Infrastructure & Plan
Before making any changes to your infrastructure, it's essential to validate your Terraform configurations and review the planned changes. This ensures that your infrastructure changes align with your expectations and do not cause unintended consequences.

#### Validation Steps

##### 1. Validate Terraform Configuration
```bash
terraform validate
```
- Validates the syntax and configuration of your Terraform files without executing any actions.

##### 2. Generate Terraform Plan
```bash
terraform plan
```
- Generates an execution plan based on the current state of your infrastructure and the proposed changes specified in your Terraform configuration files.
- The plan highlights additions, modifications, or deletions of resources.

### Review Plan Output
- Carefully review the output of the `terraform plan` command to ensure it matches your expectations.
- Verify that the planned changes align with your infrastructure requirements and objectives.
- Pay attention to any potential disruptions or unintended changes.

---

### Deploying Infrastructure:
- Apply the Terraform configuration using `terraform apply` command to deploy the infrastructure resources to the Kind cluster.
- If the plan output looks correct and aligns with your intentions, you can proceed to apply the changes.
```bash
terraform apply
```
- Applies the changes described in the execution plan to your infrastructure.
- Terraform will prompt for confirmation before applying any changes.

---

### Making changes to /etc/hosts:
1. Add an entry to your `/etc/hosts` file to map the hostname to the IP address of the Kind cluster.

---

### Cleanup:
1. After completing the testing or when you no longer need the resources, execute `terraform destroy` to delete the deployed infrastructure.
2. Delete the Kind cluster using the `kind delete cluster` command.

---

### License:
This project is licensed under the [MIT License](link_to_license).
