# Contract

These are the names, ports and metrics that more than one person's work depends on. **Don't rename anything here unless all three agree.** Adding new items is fine.

**Owner:** Bhavana · Drafted by Devika · Status: waiting for approval

## The app

| What | Value |
|---|---|
| Name | `orders-api` |
| Port | `8000` |
| Image | `orders-api:1.0.0`. Bump the version on every code change. Never use `latest`. |
| Namespace | `demo-app` (the monitoring stack goes in `monitoring`) |
| Label | `app.kubernetes.io/name: orders-api` |
| Annotations (so Prometheus finds it) | `prometheus.io/scrape: "true"`, `prometheus.io/port: "8000"`, `prometheus.io/path: "/metrics"` |
| Service | `orders-api`, port 80, NodePort `30080` |

## App endpoints

| Endpoint | What it does |
|---|---|
| `GET /` | Shows the version and which pod answered |
| `GET /health` | Liveness check (200 = OK, 500 = broken) |
| `GET /ready` | Readiness check (200 = ready, 503 = not ready) |
| `GET /api/orders` | Lists orders |
| `POST /api/orders` | Creates an order: `{"product": "book", "quantity": 1}`. Products: book, laptop, phone, headphones, keyboard. |
| `GET /api/slow` | Waits 0.3–2 s (for latency graphs) |
| `POST /admin/break-liveness` | Makes `/health` fail, for the restart demo |
| `POST /admin/toggle-ready` | Turns readiness on/off |
| `POST /admin/error-rate` | `{"rate": 0.5}` makes 50% of new orders fail |
| `GET /metrics` | Metrics for Prometheus |

## App metrics

| Metric | Type | Labels |
|---|---|---|
| `http_requests_total` | counter | `method`, `endpoint`, `status` |
| `http_request_duration_seconds` | histogram | `endpoint` |
| `http_requests_in_progress` | gauge | none |
| `orders_created_total` | counter | `product` |
| `orders_in_store` | gauge | none |
| `app_info` | gauge (always 1) | `version` |

`endpoint` is the route (like `/api/orders`), never the full URL. Prometheus adds the labels `namespace`, `pod`, `app` and `node`. Dashboards filter with `app="orders-api"`.

## Monitoring

| What | Value |
|---|---|
| Prometheus | `prometheus.monitoring.svc.cluster.local:9090`, NodePort `30090` |
| Grafana | `grafana.monitoring.svc.cluster.local:3000`, NodePort `30030` |
| Grafana data source UID | `prometheus` |
| Dashboard UIDs | `app-overview` (Divyanth), `k8s-workloads` (Devika), `node-platform` (Bhavana) |
| Grafana password | Only in the Ansible Vault file, never in plain text |

## Versions

Checked on 2026-11-26.

| Tool | Version |
|---|---|
| Python image | `python:3.12-slim` |
| Flask / prometheus-client / gunicorn / pytest | 3.1.3 / 0.26.0 / 26.2.0 / 9.2.0 |
| Kubernetes / kubectl / Minikube | v1.37.0 / v1.37.2 / v1.39.0 |
| Prometheus | `prom/prometheus:v3.15.1` |
| node-exporter | `prom/node-exporter:v1.12.1` |
| kube-state-metrics | `registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.20.0` |
| Grafana | `grafana/grafana:13.2.6` |
| Load generator | `curlimages/curl:8.23.0` |
| Ansible | ansible-core 2.21.x (2.22 needs Python 3.13; Ubuntu 24.04 has 3.12) |
| Ansible collections | kubernetes.core 6.x, community.docker 5.x, ansible.posix 2.x |

## Approval

- [ ] Divyanth
- [ ] Devika
- [ ] Bhavana
