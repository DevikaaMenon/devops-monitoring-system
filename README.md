# DevOps Monitoring Platform (Project 31)

A sample order API runs on a local Kubernetes cluster. Prometheus scrapes its application metrics and the cluster's infrastructure metrics, and Grafana shows them on dashboards. Ansible installs the tools, deploys everything and checks that it works.

```text
orders-api (Flask) → Docker image → Kubernetes (Minikube) → Prometheus → Grafana
                         ↑ everything installed, deployed and verified by Ansible ↑
```

> **Status:** Phase 1 (planning and repo setup). Nothing is deployable yet. **What to do next: [PLAN.md](PLAN.md)** (a checklist per person). Step-by-step details: [docs/reference/detailed-plan.md](docs/reference/detailed-plan.md).

## Repository layout

| Path | Contents | Owner |
|---|---|---|
| `app/` | Flask app, tests, Dockerfile | Divyanth |
| `k8s/app/` | Application manifests (Deployment, Service, ConfigMap, quota, loadgen) | Divyanth (quota: Devika, loadgen: Bhavana) |
| `k8s/monitoring/` | Prometheus, node-exporter, kube-state-metrics, Grafana | Bhavana / Devika |
| `grafana/dashboards/` | Provisioned dashboard JSON (one per member) | all three |
| `ansible/` | Inventory, variables, Vault, roles, playbooks | Devika (structure) + one role per member |
| `scripts/` | Bootstrap, readiness check, chaos and scaling helpers | various |
| `docs/` | Plan, contract, test report, diagrams, screenshots, report | all |

## Getting started (Phase 1)

```bash
git clone https://github.com/DevikaaMenon/devops-monitoring-system.git && cd devops-monitoring-system
./scripts/check-env.sh "<your name>" <M1|M2|M3>    # T1.4 (Divyanth M1, Devika M2, Bhavana M3): paste the row into docs/environment.md
```

Then read, in order:
1. [PLAN.md](PLAN.md): find your name and your task list
2. [docs/CONTRACT.md](docs/CONTRACT.md): approve it in its PR
3. [CONTRIBUTING.md](CONTRIBUTING.md): branches, reviews, file ownership

## Quick start (available after Phase 8)

```bash
./scripts/bootstrap.sh                          # once: installs Ansible in a venv
cd ansible
ansible-playbook install.yml -K                 # once: Docker, kubectl, Minikube (then log out and back in)
ansible-playbook deploy.yml --ask-vault-pass    # cluster + app + monitoring + verification
```

| Service | URL |
|---|---|
| orders-api | `http://$(minikube ip):30080` |
| Prometheus | `http://$(minikube ip):30090` |
| Grafana | `http://$(minikube ip):30030` |

## Team

| Role | Name |
|---|---|
| M1 Application & Workload | Divyanth |
| M2 Automation & Platform | Devika |
| M3 Observability | Bhavana |
