# SimpleTimeService

## Overview
SimpleTimeService is a lightweight microservice built in **Go** that returns the current timestamp and the requester's IP address in JSON format. It is containerized using **Docker**, deployed with **Kubernetes**, and managed with **Helm**. A CI/CD pipeline using **GitHub Actions** automates the build, test, and deployment process.

## Features
- Exposes an HTTP endpoint (`/`) that responds with:
  ```json
  {
    "timestamp": "<current-date-time>",
    "ip": "<requester's-ip-address>"
  }
  ```
- Runs as a **non-root user** in a minimal **distroless** Docker image.
- Kubernetes manifests and Helm chart included.
- Automated CI/CD pipeline with GitHub Actions.

## Technologies Used
- **Go** for service implementation
- **Docker** for containerization
- **Kubernetes** for deployment
- **Helm** for package management
- **GitHub Actions** for CI/CD automation
- **DockerHub** for container registry

## Getting Started
### Prerequisites
Ensure you have the following installed:
- [Go](https://go.dev/dl/)
- [Docker](https://docs.docker.com/get-docker/)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/) or a Kubernetes cluster

### Clone the Repository
```sh
git clone https://github.com/yishvendrabaghel/particle41.git
cd particle41
```

### Running Locally
#### Build and Run the Application
```sh
go build -o SimpleTimeService
./SimpleTimeService
```
#### Test the API
```sh
curl http://localhost:8080/
```
Expected response:
```json
{
  "timestamp": "2025-02-12T14:25:36Z",
  "ip": "127.0.0.1"
}
```

## Docker Usage
### Build and Run with Docker
#### Build the Docker Image
```sh
docker build -t yishu91/simpletimeservice .
```
#### Run the Docker Container
```sh
docker run -d -p 8080:8080 yishu91/simpletimeservice
```
#### Pull the Prebuilt Image from DockerHub
```sh
docker pull yishu91/simpletimeservice
```

#### Build and Push the Image to DockerHub
```sh
docker build -t <image_name>:<tag> .
docker login
docker tag <image_name>:<tag> <dockerhub-username>/simpletimeservice:latest
docker push <dockerhub-username>/simpletimeservice:latest
```

## Kubernetes Deployment
### Install NGINX Ingress Controller (if not installed)
```sh
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0/deploy/static/provider/cloud/deploy.yaml
```

### Apply Kubernetes Manifests
```sh
kubectl apply -f k8s/deployment.yaml
```
Check if the pods are running:
```sh
kubectl get pods
kubectl get ing
```
Copy the **ADDRESS** from the `kubectl get ing` output and resolve it:
```sh
nslookup <ADDRESS_URL>
```
Example output:
```sh
Non-authoritative answer:
Name:   example-loadbalancer.amazonaws.com
Address: 52.22.60.185
```

Edit your `/etc/hosts` file and add:
```sh
52.22.60.185 simple-time.local
```
Now, access the service in your browser:
```sh
simple-time.local
```

## Helm Deployment
### Install the Helm Chart
```sh
helm install simpletimeservice helm/
```
Verify the release:
```sh
helm list
```

## CI/CD Pipeline
The GitHub Actions workflow automates:
1. Building and testing the Go application
2. Building and pushing the Docker image to **DockerHub**
3. Deploying the service to **Kubernetes** using Helm

### Setting Up GitHub Secrets
Before running the GitHub Actions pipeline, configure repository secrets:

1. **DOCKERHUB_USERNAME** → Your DockerHub username
2. **DOCKERHUB_TOKEN** → DockerHub token (Generate in DockerHub > Account Settings > Access Tokens)
3. **GITHUB_TOKEN** → GitHub Personal Access Token (Generate in GitHub > Settings > Developer Settings > Personal Access Tokens)

### Triggering the Pipeline
- The workflow runs **automatically** on every push to `main`.
- You can trigger it manually from the GitHub Actions tab.

---

🎉 **Congratulations!** You have successfully built, containerized, and deployed SimpleTimeService using Kubernetes and Helm with full CI/CD automation!

