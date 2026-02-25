from flask import Flask, Response
from prometheus_client import Counter, Histogram, generate_latest
import time
import random

app = Flask(__name__)

REQUEST_COUNT = Counter(
    "http_requests_total",
    "Total HTTP Requests",
    ["method", "endpoint", "http_status"]
)

REQUEST_LATENCY = Histogram(
    "http_request_duration_seconds",
    "HTTP request latency"
)

@app.route("/")
def home():
    with REQUEST_LATENCY.time():
        status = 200
        if random.random() < 0.1:  # 10% erro
            status = 500

        REQUEST_COUNT.labels("GET", "/", status).inc()

        if status == 500:
            return "Internal Error", 500

        return "SRE Demo App", 200


@app.route("/metrics")
def metrics():
    return Response(generate_latest(), mimetype="text/plain")

@app.route("/kill")
def kill():
    import os
    os._exit(1)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)