# Run Jenkins in Docker (recommended for local/demo)

This runs Jenkins in Docker and mounts the host Docker socket so Jenkins can build and push images.

1. Create a Docker volume for Jenkins data:
   docker volume create jenkins-data

2. Run Jenkins container (Linux/macOS):
   docker run -d --name jenkins      -p 8080:8080 -p 50000:50000      -v jenkins-data:/var/jenkins_home      -v /var/run/docker.sock:/var/run/docker.sock      -v $(which docker):/usr/bin/docker      jenkins/jenkins:lts

(If on Windows with Docker Desktop, adapt volume paths accordingly. Mounting docker CLI binary may not be needed.)

3. Open Jenkins at http://localhost:8080 and complete setup. Install suggested plugins including:
   - Docker Pipeline
   - SSH Agent
   - Git
   - Pipeline
   - Credentials Binding
   - SonarQube Scanner (optional)

4. Add credentials in Jenkins:
   - DockerHub username/password (ID: dockerhub-creds)
   - SSH private key (ID: target-ssh-key) for deployment server
   - SonarQube token (ID: sonar-token) as "Secret text"
   - (Optional) Sonar host URL as "Secret text" with ID sonar-host-url

5. Create a pipeline job pointing to this repository and let it run the Jenkinsfile.

Security notes:
- Mounting the Docker socket gives Jenkins full control over Docker on the host. Only do this on trusted machines.
- For production, run Jenkins with a dedicated service account, and prefer using a Jenkins agent with Docker-in-Docker or Kubernetes agents.
