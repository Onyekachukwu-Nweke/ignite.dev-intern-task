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
- [KinD Setup]()
- [Terraform Setup]()
- [Terraform Configurations]()
- [Deploying Infrastructure]()
- [Cleanup]
- [License]

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
1. Execute the provided `setup_cluster.sh` bash script to create a Kind cluster with desired configurations.

---

### Terraform Setup:
1. Clone the repository containing Terraform configurations for deploying infrastructure.

---

### Terraform Configurations:
1. Modify the Terraform configuration files (`main.tf`, `variables.tf`, etc.) to define the infrastructure resources you want to deploy.
2. Ensure you have provided necessary input variables such as cluster name, Docker image details, etc.

---

### Deploying Infrastructure:
1. Apply the Terraform configuration using `terraform apply` command to deploy the infrastructure resources to the Kind cluster.

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
