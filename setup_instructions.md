# Step-by-step: Setup Jenkins CI/CD (summary)

1. Prepare your target server (deploy host)
   - Install Docker and Docker Compose (v2).
   - Create a user (e.g., ec2-user) and add SSH key for Jenkins to use.

2. Run Jenkins in Docker (on your workstation or a server)
   - docker volume create jenkins-data
   - docker run -d --name jenkins -p 8080:8080 -p 50000:50000 \
       -v jenkins-data:/var/jenkins_home \
       -v /var/run/docker.sock:/var/run/docker.sock \
       -v $(which docker):/usr/bin/docker \
       jenkins/jenkins:lts

3. Install Jenkins plugins:
   - Docker Pipeline, SSH Agent, Git, Pipeline, Credentials Binding, SonarQube Scanner

4. Add credentials in Jenkins:
   - GitHub (optional, for webhooks)
   - DockerHub creds (id: dockerhub-creds)
   - SSH private key (id: target-ssh-key)
   - Sonar token (id: sonar-token)
   - Sonar host URL (id: sonar-host-url) (or set SONAR_HOST in pipeline)

5. Create a Pipeline job pointing to your GitHub repo or use a Multibranch Pipeline.

6. Update `Jenkinsfile` environment variables:
   - Replace TARGET_HOST with your server IP/hostname
   - Replace DOCKERHUB_REPO with your Docker Hub repo (user/image)

7. Configure GitHub webhook to notify Jenkins (optional)
   - In GitHub repo -> Settings -> Webhooks -> Add webhook: http://JENKINS_HOST:8080/github-webhook/

8. Run the pipeline.

Notes:
- SonarQube: For full SonarQube scans, run a SonarQube server (docker run -d --name sonarqube -p 9000:9000 sonarqube:latest) and use a token from it.
- Gitleaks/Trivy: We use stable Docker images to run scans in the pipeline.

