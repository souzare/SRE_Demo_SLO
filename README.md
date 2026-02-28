# SRE SLO Demo -- Main Environment

## Overview

This demo demonstrates real-world SRE concepts using:

-   AWS ECS Fargate
-   AWS Cloud Map (Service Discovery)
-   Prometheus
-   Grafana
-   SLI / SLO / Error Budget concepts

Architecture includes:

-   `sre-app-service`
-   `sre-observability-service`
-   Cloud Map namespace: `sre.local`

------------------------------------------------------------------------

# Architecture

-   VPC with public subnet
-   ECS Cluster
-   App Service (Python + /metrics endpoint)
-   Observability Service (Prometheus + Grafana)
-   Service discovery via Cloud Map
-   Prometheus scrapes app via DNS

------------------------------------------------------------------------

# Prerequisites

-   AWS CLI configured
-   Docker installed
-   Docker buildx enabled
-   IAM permissions for ECS, ECR, CloudFormation, Cloud Map

------------------------------------------------------------------------

# Step 1 -- Build and Push Images

``` bash
./build-and-push.sh
```

------------------------------------------------------------------------

# Step 2 -- Deploy Infrastructure

``` bash
./deploy.sh
```

Wait until CloudFormation stack is `CREATE_COMPLETE`.

------------------------------------------------------------------------

# Step 3 -- Validate Targets

Access:

    http://<OBSERVABILITY_IP>:9090/targets

Ensure:

    sre-app-service.sre.local:5000 → UP

------------------------------------------------------------------------

# Step 4 -- Configure Grafana

Access:

    http://<OBSERVABILITY_IP>:3000

Login: - user: admin - pass: admin

Add Prometheus datasource:

URL:

    http://localhost:9090

------------------------------------------------------------------------

# Step 5 -- Create Dashboard

## SLI Panel (Success Rate)

PromQL:

``` promql
sum(rate(http_requests_total{http_status=~"2.."}[5m]))
/
clamp_min(sum(rate(http_requests_total[5m])), 0.00001)
```

Settings: - Visualization: Stat - Unit: Percent (0-1) - Min: 0 - Max:
1 - Thresholds: - 0.99 → Green - 0.97 → Yellow

------------------------------------------------------------------------

## Error Rate Panel

``` promql
sum(rate(http_requests_total{http_status!~"2.."}[5m]))
```

Visualization: Time Series

------------------------------------------------------------------------

# Step 6 -- Generate Normal Traffic

``` bash
while true; do curl http://<APP_IP>:5000; done
```

SLI should approach 100%.

------------------------------------------------------------------------

# Step 7 -- Simulate Partial Failure

``` bash
while true; do curl http://<APP_IP>:5000/fail; done
```

Observe: - Error rate increases - SLI drops below 99%

------------------------------------------------------------------------

# Step 8 -- Simulate Full Failure

``` bash
curl http://<APP_IP>:5000/kill
```

Observe: - ECS recreates task - DNS updates automatically - Prometheus
target temporarily DOWN - SLI drops significantly

------------------------------------------------------------------------

# Teaching Objectives

-   Explain SLI vs SLO
-   Demonstrate error budget consumption
-   Show service discovery in action
-   Highlight distributed system behavior (TTL, eventual consistency)

------------------------------------------------------------------------

# Key Message

SRE is not about 100% uptime.\
It is about managing risk with data.
