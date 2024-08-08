---
title: "Alertmanger configuration to send alerts to webhook"
date: 2024-08-08T17:00:00Z
draft: false
tags: ["DevOps", "Observability", "Prometheus", "Alertmanager"]
thumbnail: "https://j-santana-dev.github.io/itguynextdoor.github.io/nothingtoseehere.jpg"
description: "Configure Alertmanager to send alerts to a webhook"
---

## Introduction
Alertmanager is an open-source alerting system that works with Prometheus. It handles alerts sent by client applications such as the Prometheus server or Grafana. 

In this article, I will show you how to configure Alertmanager to send alerts to your own webhook application.

## Versions
In the time of writing this article, the versions I used are:
- Alertmanager: v0.27.0
- Prometheus: v2.45.0
- Grafana: v10.4.2

## Context
Recently, I had to configure Alertmanager to send alerts to a webhook application over HTTP.
My stack is composed of the following components:
- N number of Prometheus instances
- N number of Alertmanager instances
- N number of Grafana instances
- N number of Webhook instances

## What is expected
When an alert is triggered from Grafana (based on metrics from Prometheus), it is sent to all Alertmanager instances in parallel through the Grafana's contact point.
The Alertmanager instances are in cluster mode, so they share the same configuration. When an alert is received, Alertmanager coordinates the alerts and sends them to the Webhook instances with no duplicates.

## Components
I will work with the following components for this example test:
- Grafana: to create dashboards and alerts
- Prometheus: to collect metrics
- Alertmanager: to handle alerts from Grafana alerts
- webhook application: to receive alerts from Alertmanager and do whatever you want with them.
- Nginx: to route the requests among the components

## Docker-compose
In order to test the configuration, I created a `docker-compose.yml` file with the following content:

```yaml
version: '3'

services:
  grafana:
    container_name: grafana
    image: grafana/grafana:10.4.2
    ports:
      - "3000:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - ./docker/grafana/datasource.yml:/etc/grafana/provisioning/datasources/datasource.yaml
      - ./docker/grafana/contact-point.yml:/etc/grafana/provisioning/alerting/contact-point.yaml
      - ./docker/grafana/dashboard-provider.yml:/etc/grafana/provisioning/dashboards/default.yaml

  prometheus1:
    container_name: prometheus1
    image: prom/prometheus:v2.45.0
    volumes:
      - ./docker/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9090:9090"

  prometheus2:
    container_name: prometheus2
    image: prom/prometheus:v2.45.0
    volumes:
      - ./docker/prometheus.yml:/etc/prometheus/prometheus.yml
    ports:
      - "9091:9090"

  alertmanager1:
    container_name: alertmanager1
    image: prom/alertmanager:v0.27.0
    volumes:
      - ./docker/alertmanager1.yml:/etc/alertmanager/config.yml
    command:
      - '--config.file=/etc/alertmanager/config.yml'
      - '--cluster.peer=alertmanager2:9094'
      - '--log.level=debug'
    ports:
      - "9093"
      - "9094/udp" # This port is used for gossip
      - "9094/tcp"

  alertmanager2:
    container_name: alertmanager2
    image: prom/alertmanager:v0.27.0
    volumes:
      - ./docker/alertmanager2.yml:/etc/alertmanager/config.yml
    command:
      - '--config.file=/etc/alertmanager/config.yml'
      - '--cluster.peer=alertmanager1:9094'
      - '--log.level=debug'
    ports:
      - "9093"
      - "9094/udp" # This port is used for gossip
      - "9094/tcp"

  echo1:
    container_name: echo1
    image: ealen/echo-server:latest
    ports:
      - "8081:80"

  echo2:
    container_name: echo2
    image: ealen/echo-server:latest
    ports:
      - "8082:80"

  nginx:
    container_name: nginx
    image: nginx:latest
    volumes:
      - ./docker/nginx.conf:/etc/nginx/nginx.conf
    ports:
      - "80:80"
```

## Nginx configuration
Nginx is used to route the requests among some components. In this case, I will use it to route the requests from grafana to promehteus datasource, and from alertmanager to webhooks.

```nginx
events {
  worker_connections 1024;
}

http {
  upstream prometheus {
    server prometheus1:9090;
    server prometheus2:9090;
  }

  upstream echo {
    server echo1:80;  
    server echo2:80;  
  }

  server {
    listen 80;

    location /prometheus {
      rewrite ^/prometheus(.*) $1 break;
      proxy_pass http://prometheus;
    }

    location /echo {
       proxy_pass http://echo;
    }
  }
}
```

## Prometheus configuration
All the Prometheus have the same configuration:

```yaml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['prometheus1:9090', 'prometheus2:9090']

alerting:
  alertmanagers:
    - static_configs:
        - targets: ['alertmanager1:9093', 'alertmanager2:9093']
```

In the same way, we have the following configuration for datasource, contact-point, and dashboard-provider:

`datasource.yml`
```yaml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://nginx:80/prometheus
    isDefault: true
    editable: true
```

`contact-point.yml`
```yaml
apiVersion: 1

contactPoints:
  - orgId: 1
    name: Alertmanager
    receivers:
      - uid: alertmanager1
        type: prometheus-alertmanager
        settings:
          url: http://alertmanager1:9093

      - uid: alertmanager2
        type: prometheus-alertmanager
        settings:
          url: http://alertmanager2:9093
```

`dashboard-provider.yml`
```yaml
apiVersion: 1

providers:
  - name: Default
    folder: Dashboards
    type: file
    options:
      path: /var/lib/grafana/dashboards
```

## Alertmanager configuration
The Alertmanager instances have the same configuration and they are in cluster mode.

```yaml
global:
  resolve_timeout: 24h

route:
  group_by: ['alertname']
  group_wait: 1m
  group_interval: 5m
  repeat_interval: 10m
  receiver: 'echo'

receivers:
  - name: 'echo'
    webhook_configs:
      - url: 'http://nginx:80/echo'

inhibit_rules:
  - source_match:
      severity: critical
    target_match:
      severity: warning
    equal: ['alertname']
```

## Webhook application
For our example test, I used an echo server that returns the request body. You can use any application that receives the alerts from Alertmanager using HTTP protocol.

## Run and test
```bash
docker-compose up
```

You can create a dashboard in Grafana and set an alert to test the configuration. You can check the logs of the Alertmanager and the echo server to see the alerts being sent!

## Conclusion
One of the most important things that I've learned from this experience is that you never should put your Alertmanager instances under a round-robin load balancer. This can end up with inconsistent behavior.

All your Alertmanager instances should be called in parallel by the client applications (like Grafana or Prometheus).

---

![Would you like to know more?](https://j-santana-dev.github.io/itguynextdoor.github.io/know-more.png)

You can check the official Alertmanager documentation [here](https://prometheus.io/docs/alerting/latest/alertmanager/). Pay attention to the configuration options and the best practice to avoid misbehaviors.