# Interface Contract

**Version:** 1.0 (draft, waiting for M1/M2/M3 approval)
**Owner:** M3 · **Reviewers:** M1, M2
**Task:** T1.2

This file defines every name, port, label and metric that crosses a team member's boundary. Once all three members approve the PR that adds it, the contract is **frozen**. After that, a change needs a PR approved by all three. New items can be added; existing ones are never renamed.

---

## 1. Namespaces

| Namespace | Contains |
|---|---|
| `demo-app` | `orders-api`, `loadgen`, LimitRange, ResourceQuota |
| `monitoring` | `prometheus`, `grafana`, `node-exporter`, `kube-state-metrics` |

## 2. Application: `orders-api`

| Item | Value |
|---|---|
| Container port | `8000` (port name `http`) |
| Image | `orders-api:<semver>`, starting at `orders-api:1.0.0`. **Never `latest`.** Any code change bumps the version. |
| Pod + selector labels | `app.kubernetes.io/name: orders-api`<br>`app.kubernetes.io/part-of: monitoring-platform` |
| Pod annotations | `prometheus.io/scrape: "true"`<br>`prometheus.io/port: "8000"`<br>`prometheus.io/path: "/metrics"` |
| Service | `orders-api` (type NodePort), port `80` → targetPort `http`, nodePort `30080` |
| In-cluster DNS | `orders-api.demo-app.svc.cluster.local` |
| Config (ConfigMap `orders-api-config`) | `APP_VERSION`, `ERROR_RATE` |
| Env from Downward API | `POD_NAME` (from `metadata.name`) |

### Endpoints

| Method | Path | Purpose | Responses |
|---|---|---|---|
| GET | `/` | Service info (`service`, `version`, `pod`) | 200 |
| GET | `/health` | Liveness probe | 200 ok / 500 broken |
| GET | `/ready` | Readiness probe | 200 ready / 503 not ready |
| GET | `/api/orders` | List the latest 20 orders | 200 |
| POST | `/api/orders` | Create an order. Body: `{"product": "...", "quantity": n}` | 201 / 400 unknown product / 500 injected failure |
| GET | `/api/slow` | Sleeps 0.3–2.0 s (latency source) | 200 |
| POST | `/admin/break-liveness` | Make `/health` return 500 from now on | 202 |
| POST | `/admin/toggle-ready` | Flip readiness on/off | 200 |
| POST | `/admin/error-rate` | Body `{"rate": 0.0–1.0}`: fraction of POST `/api/orders` that fail | 200 |
| GET | `/metrics` | Prometheus exposition format | 200 |

Valid products: `book`, `laptop`, `phone`, `headphones`, `keyboard`.

## 3. Application metrics (names are final)

| Metric | Type | Labels | Meaning |
|---|---|---|---|
| `http_requests_total` | counter | `method`, `endpoint`, `status` | Requests served. `endpoint` is the route template (e.g. `/api/orders`), never a raw URL. `/metrics` itself is not counted. |
| `http_request_duration_seconds` | histogram | `endpoint` | Request latency. Buckets: `0.01 0.025 0.05 0.1 0.25 0.5 1 2.5 5` |
| `http_requests_in_progress` | gauge | none | Requests being served right now |
| `orders_created_total` | counter | `product` | Successfully created orders |
| `orders_in_store` | gauge | none | Orders held in this pod's memory |
| `app_info` | gauge (always 1) | `version` | Running build version |

**Label rule:** no unbounded values (IDs, user input) in labels.

## 4. Labels added by Prometheus relabeling

| Label | Source |
|---|---|
| `namespace` | `__meta_kubernetes_namespace` |
| `pod` | `__meta_kubernetes_pod_name` |
| `app` | pod label `app.kubernetes.io/name` |
| `node` | `__meta_kubernetes_pod_node_name` |

Dashboards and alert rules filter the application with `app="orders-api"`.

## 5. Monitoring endpoints

| Component | In-cluster address | External access |
|---|---|---|
| Prometheus | `prometheus.monitoring.svc.cluster.local:9090` | NodePort `30090` |
| Grafana | `grafana.monitoring.svc.cluster.local:3000` | NodePort `30030` |
| kube-state-metrics | `kube-state-metrics.monitoring.svc.cluster.local:8080` | none |
| node-exporter | headless Service `node-exporter.monitoring`, port `9100` | none |

- Grafana data source **name** `Prometheus`, **UID** `prometheus`. Every dashboard JSON references this UID.
- Dashboard UIDs: `app-overview` (M1), `k8s-workloads` (M2), `node-platform` (M3).
- Grafana admin password: only in `ansible/group_vars/all/vault.yml` (Ansible Vault). Never committed in plain text.

## 6. Prometheus scrape jobs

| Job name | Discovery | Scrapes |
|---|---|---|
| `prometheus` | static | Prometheus itself |
| `kubernetes-pods` | `role: pod` + annotation filter | `orders-api` pods |
| `node-exporter` | `role: endpoints`, Service `node-exporter` | Node metrics |
| `kube-state-metrics` | static (Service DNS) | Kubernetes object state |
| `kubernetes-cadvisor` | `role: node`, via API-server proxy | Container CPU/memory |

## 7. Pinned versions

Checked against the official release pages and registries on 2026-11-26. Each release was chosen as the newest stable one that is at least two weeks old.

| Component | Version | Used in |
|---|---|---|
| Python base image | `python:3.12-slim` | Dockerfile (matches Ubuntu 24.04's Python 3.12 for local dev) |
| Flask | `3.1.3` | `app/requirements.txt` |
| prometheus-client | `0.26.0` | `app/requirements.txt` |
| gunicorn | `26.2.0` | `app/requirements.txt` |
| pytest | `9.2.0` | `app/requirements-dev.txt` |
| Kubernetes (cluster) | `v1.37.0` | `minikube start --kubernetes-version` (Minikube's default) |
| kubectl | `v1.37.2` | `k8s_tools` role |
| Minikube | `v1.39.0` | `k8s_tools` role |
| Docker Engine | CE 29.x (from Docker's apt repo) | `docker` role |
| Prometheus | `prom/prometheus:v3.15.1` | monitoring manifests |
| node-exporter | `prom/node-exporter:v1.12.1` | monitoring manifests |
| kube-state-metrics | `registry.k8s.io/kube-state-metrics/kube-state-metrics:v2.20.0` | monitoring manifests |
| Grafana OSS | `grafana/grafana:13.2.6` | monitoring manifests |
| Load generator | `curlimages/curl:8.23.0` | `k8s/app/40-loadgen.yaml` |
| ansible-core | `>=2.21,<2.22` (2.22 requires Python 3.13; Ubuntu 24.04 ships 3.12) | `scripts/bootstrap.sh` |
| kubernetes.core | `>=6.6.0,<7.0.0` | `ansible/requirements.yml` |
| community.docker | `>=5.4.0,<6.0.0` | `ansible/requirements.yml` |
| ansible.posix | `>=2.2.2,<3.0.0` | `ansible/requirements.yml` |

The plan (`docs/PROJECT_PLAN.md`) was written against Prometheus 2.x. With Prometheus 3.x, the config in T6.2 still applies, but the web UI looks different, so screenshots won't match older tutorials.

---

## Approval

| Member | Role | Approved (PR review) | Date |
|---|---|---|---|
| M1 | Application & Workload | ☐ | |
| M2 | Automation & Platform | ☐ | |
| M3 | Observability | ☐ | |
