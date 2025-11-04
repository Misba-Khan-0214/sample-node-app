# Sample Node.js App + Jenkins CI/CD Pipeline

This repo contains:
- a minimal Express app (`index.js`)
- `Dockerfile` for containerizing the app
- `docker-compose.yml` for deployment on target server
- `Jenkinsfile` demonstrating a CI/CD pipeline with:
  - checkout, build, tests
  - Gitleaks, SonarQube, Trivy scans
  - Docker image build & push to Docker Hub
  - Deployment over SSH using Docker Compose
- helper scripts for scans and deployment

## Quick local run
1. Install dependencies: `npm install`
2. Start: `node index.js` or `docker build -t sample-node-app . && docker run -p 3000:3000 sample-node-app`

## Files of interest
- Jenkinsfile: CI pipeline
- docker-compose.yml: production compose
- scripts/: gitleaks, sonar-scanner, trivy helper scripts

See the instructions below (detailed steps) for how to set up Jenkins in Docker and configure credentials.
