aws cloudformation deploy \
  --template-file /Users/doctor/gitrepo/SRE_Demo_SLO/cloudformation/main.yaml \
  --stack-name sre-slo-demo \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    AppImage=640388149711.dkr.ecr.us-east-1.amazonaws.com/sre-app:latest \
    PromImage=640388149711.dkr.ecr.us-east-1.amazonaws.com/sre-prometheus:latest \
    GrafanaImage=640388149711.dkr.ecr.us-east-1.amazonaws.com/sre-grafana:latest