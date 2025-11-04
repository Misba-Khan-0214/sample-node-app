=pipeline {
  agent any
  environment {
    DOCKERHUB_CREDENTIALS = 'dockerhub-creds'
    SSH_CREDENTIALS = 'target-ssh-key'
    SSH_USER = 'ec2-user'
    TARGET_HOST = '13.233.255.94'
    DOCKERHUB_REPO = 'misba0214/sample-node-app'
    IMAGE_TAG = "latest"

    // Hardcoded SonarQube values
    SONAR_HOST = "http://host.docker.internal:9000"
    SONAR_TOKEN = credentials('jenkins-sonar')   // keep token as a secret
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Install & Test') {
      steps {
        echo "📦 Installing dependencies and running tests"
        nodejs('Node18') {
          sh '''
            npm install
            npm start &
            sleep 5
            npm test
            pkill node || true
          '''
        }
      }
    }

    stage('Gitleaks Scan') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/src -w /src zricethezav/gitleaks:latest \
          detect --source=. --report-format=json --report-path=gitleaks-report.json || true
          echo "Gitleaks report saved to gitleaks-report.json"
        '''
        archiveArtifacts artifacts: 'gitleaks-report.json', allowEmptyArchive: true
      }
    }

    stage('SonarQube Analysis') {
      steps {
        sh '''
          docker run --rm -v $(pwd):/usr/src -w /usr/src sonarsource/sonar-scanner-cli \
          -Dsonar.projectKey=sample-node-app \
          -Dsonar.sources=. \
          -Dsonar.host.url=$SONAR_HOST \
          -Dsonar.login=$SONAR_TOKEN || true
        '''
      }
    }

    stage('Build Docker Image') {
      steps {
        sh "docker build -t ${DOCKERHUB_REPO}:${IMAGE_TAG} ."
      }
    }

    stage('Trivy Scan Image') {
      steps {
        sh '''
          docker run --rm aquasec/trivy:latest image \
          --format json --output trivy-report.json ${DOCKERHUB_REPO}:${IMAGE_TAG} || true
        '''
        archiveArtifacts artifacts: 'trivy-report.json', allowEmptyArchive: true
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKERHUB_USER', passwordVariable: 'DOCKERHUB_PASS')]) {
          sh '''
            echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
            docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
            docker logout
          '''
        }
      }
    }

    stage('Deploy to Target') {
      steps {
        sshagent (credentials: [SSH_CREDENTIALS]) {
          sh '''
            scp -o StrictHostKeyChecking=no docker-compose.yml ${SSH_USER}@${TARGET_HOST}:/tmp/docker-compose.yml
            ssh -o StrictHostKeyChecking=no ${SSH_USER}@${TARGET_HOST} \
            "docker pull ${DOCKERHUB_REPO}:${IMAGE_TAG} || true && docker compose -f /tmp/docker-compose.yml up -d --remove-orphans"
          '''
        }
      }
    }
  }

  post {
    always {
      archiveArtifacts artifacts: 'gitleaks-report.json,trivy-report.json', allowEmptyArchive: true
    }
  }
}
