#!/bin/bash

ACCOUNT_ID=640388149711
REGION=us-east-1

ECR_BASE=$ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

echo "Criando repositórios no ECR..."

aws ecr create-repository --repository-name sre-app --region $REGION || true
aws ecr create-repository --repository-name sre-prometheus --region $REGION || true
aws ecr create-repository --repository-name sre-grafana --region $REGION || true

echo "Login no ECR..."
aws ecr get-login-password --region $REGION \
| docker login --username AWS --password-stdin $ECR_BASE

echo "Build App..."
docker build --platform linux/amd64 -t sre-app /Users/doctor/gitrepo/SRE_Demo_SLO/docker/app
docker tag sre-app:latest $ECR_BASE/sre-app:latest
docker push $ECR_BASE/sre-app:latest

echo "Build Prometheus..."
docker build --platform linux/amd64 -t sre-prometheus /Users/doctor/gitrepo/SRE_Demo_SLO/docker/prometheus
docker tag sre-prometheus:latest $ECR_BASE/sre-prometheus:latest
docker push $ECR_BASE/sre-prometheus:latest

echo "Build Grafana..."
docker build --platform linux/amd64 -t sre-grafana /Users/doctor/gitrepo/SRE_Demo_SLO/docker/grafana
docker tag sre-grafana:latest $ECR_BASE/sre-grafana:latest
docker push $ECR_BASE/sre-grafana:latest

echo "Build e Push finalizados com sucesso!"