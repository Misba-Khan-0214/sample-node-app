#!/bin/sh
docker run --rm -v $(pwd):/src -w /src zricethezav/gitleaks:latest   detect --source=. --report-format=json --report-path=gitleaks-report.json
echo "Gitleaks finished"
