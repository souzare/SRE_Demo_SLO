aws cloudformation deploy \
  --template-file cloudformation/main.yaml \
  --stack-name sre-slo-demo \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    AppImage=<ECR_APP_URI> \
    PromImage=<ECR_PROM_URI> \
    GrafanaImage=<ECR_GRAFANA_URI>