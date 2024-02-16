## Task instructions for DevOps Intern Role

### Table of Contents
- [Task instructions for DevOps Intern Role](#task-instructions-for-devops-intern-role)
  - [Table of Contents](#table-of-contents)
  - [Setup a kubernetes cluster using kind](#setup-a-kubernetes-cluster-using-kind)
  - [Deploy a sample Node.js app using terraform](#deploy-a-sample-nodejs-app-using-terraform)
  - [Bonus](#bonus)
  - [Submission](#submission)
- [Task Submission By Nweke Onyekachukwu Ejiofor](#task-submission-by-nweke-onyekachukwu-ejiofor)
  - [Prerequisites](#prerequisites)
  - [Assumptions](#assumptions)
  - [Deploying Infrastructure and its resources](#deploying-infrastructure-and-its-resources)
  - [Making changes to `/etc/hosts`:](#making-changes-to-etchosts)
  - [License:](#license)

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

### Deploying Infrastructure and its resources
To start the application, run
```bash
make all
```
You will be prompted for your docker username and password ( a personal access token ) in order to push your docker image to dockerhub and also email credentials if you want to setup alert-manager alerts for your infrastructure but it can be skipped by leaving it blank.

---

### Making changes to `/etc/hosts`:
Added entries to my `/etc/hosts` file to map the hostname and subdomains to the IP address of the Kind cluster.

```bash

![Hosts config](/img/hosts.png)

---

### Evidence of Deployed of Resources to Cluster and Alerts by Alert-Manager
1. Hello-World
![Hello](/img/hello.png)

2. Grafana Webpage
![Grafana](/img/grafana.png)

3. Prometheus Webpage
![Prometheus](/img/prometheus.png)

4. Alert Manager in Prometheus
![Alert-Manager](/img/alert-manager.png)

5. Email Alert Firing Critical
I configured email alerts with alert-manager using Mailtrap.io for sending test emails from the infrastructure

![alert-1](/img/email-alert-1.png)

![alert-2](/img/email-alert-2.png)

---

### Cleanup:
To clean up infrastructure

```bash
make destroy
```

---

### License:
This project is licensed under the [MIT License](link_to_license).
