#!/bin/sh
IMAGE=$1
if [ -z "$IMAGE" ]; then
  echo "Usage: $0 <image>"
  exit 1
fi
docker run --rm aquasec/trivy:latest image --format json --output trivy-report.json "$IMAGE"
echo "Trivy finished"
