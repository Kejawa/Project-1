# Project 1 - CI/CD Pipeline with Docker, Trivy, Jenkins

> Automated build, security scan, push and deployment pipeline for Node.js & MongoDB application on a self hosted Linux(Ubuntu) server

## Architecture

Developer pushs to Github
        |
Github Webhook 


# DevOps Project — CI/CD + Kubernetes

This project shows how I built and deployed a real application using modern DevOps tools. The goal was to automate everything, from code push to deployment — while also adding security checks and monitoring.

---

# What This Project Does

Whenever I push code to GitHub:

1. Jenkins automatically starts a pipeline
2. A Docker image is built
3. The image is scanned for vulnerabilities (Trivy)
4. If safe → it is pushed to Docker Hub
5. The app is deployed automatically
6. Kubernetes updates the app with **zero downtime**
7. Prometheus + Grafana monitor everything

---

# Tools I Used

* **Docker** → package the app into containers
* **Jenkins** → automate build + deploy
* **Trivy** → scan for security issues
* **Docker Hub** → store images
* **Kubernetes (k3s)** → run the app
* **Nginx Ingress** → expose app on port 80
* **Prometheus** → collect metrics
* **Grafana** → visualize metrics

---

# System Flow

```
GitHub Push
    ↓
Jenkins Pipeline
    ↓
Build Docker Image
    ↓
Security Scan (Trivy)
    ↓
Push to Docker Hub
    ↓
Deploy to Kubernetes
    ↓
Users access app via browser
```

---

# CI/CD Pipeline (Jenkins)

### 1. Checkout Code

Jenkins pulls the latest code from GitHub

### 2. Build Docker Image

The app is packaged into a lightweight image using Node.js Alpine.

### 3. Security Scan.

Trivy checks for vulnerabilities

* If **CRITICAL issue found → build fails**
* If safe → continue ✅

### 4. Push Image

The image is pushed to Docker Hub.

### 5. Deploy

Jenkins updates the running app automatically.

---

# Kubernetes Setup

* App runs in **2 replicas** (for availability)
* MongoDB uses **persistent storage** (data is not lost)
* Nginx Ingress exposes the app on port 80

### Zero Downtime Deployment (RollingUpdate)

When I deploy a new version:

* Kubernetes starts a new pod
* Waits for it to be ready
* Then removes the old one
Users never experience downtime

---

# Monitoring & Alerts

### Metrics

* App exposes `/metrics`
* Prometheus collects data

### Grafana Dashboards

* CPU usage
* Memory usage
* Request rate

### Alerts

* High memory usage(over 200mb)

---

# Security Practices

* No secrets in code (used environment variables)
* Docker containers run as **non-root user**
* Trivy blocks vulnerable builds
* Used Docker Hub token instead of password

---

# Run Locally

```bash
git clone https://github.com/Kejawa/Project-1.git
cd Project-1
uncomment build in compose & remmove image

cp .env.example .env
# update values

docker compose up -d --build
```

Then open:

```
http://localhost
```

---

# Note About Server

This project is hosted on a personal VPS.

The server may go offline sometimes, so the live app might not always be accessible.

However, all configurations, pipeline logic, and deployments are fully implemented and reproducible.

---

# What I Learned

* How CI/CD pipelines actually work in real life
* How to secure builds using vulnerability scanning
* Docker image optimization (multi-stage builds)
* Kubernetes deployments, services, and ingress
* Monitoring with Prometheus & Grafana
* Debugging real production-like issues

---

# Summary

This project is not just theory, it shows:

✅ Automated CI/CD pipeline
✅ Security integrated into pipeline
✅ Kubernetes deployment
✅ Monitoring & alerting

---