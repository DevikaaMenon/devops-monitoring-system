# DevOps Monitoring Platform (Project 31)

A sample order API runs on a local Kubernetes cluster. Prometheus scrapes its application metrics and the cluster's infrastructure metrics, and Grafana shows them on dashboards. Ansible installs the tools, deploys everything and checks that it works.

```text
orders-api (Flask) → Docker image → Kubernetes (Minikube) → Prometheus → Grafana
                         ↑ everything installed, deployed and verified by Ansible ↑
```

> **Status:** Phase 1 (planning and repo setup). Nothing is deployable yet. The full plan is in [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md).

## Repository layout

| Path | Contents | Owner |
|---|---|---|
| `app/` | Flask app, tests, Dockerfile | M1 |
| `k8s/app/` | Application manifests (Deployment, Service, ConfigMap, quota, loadgen) | M1 (quota: M2, loadgen: M3) |
| `k8s/monitoring/` | Prometheus, node-exporter, kube-state-metrics, Grafana | M3 / M2 |
| `grafana/dashboards/` | Provisioned dashboard JSON (one per member) | M1, M2, M3 |
| `ansible/` | Inventory, variables, Vault, roles, playbooks | M2 (structure) + one role per member |
| `scripts/` | Bootstrap, readiness check, chaos and scaling helpers | various |
| `docs/` | Plan, contract, test report, diagrams, screenshots, report | all |

## Getting started (Phase 1)

```bash
git clone <repo-url> && cd devops-monitoring-platform
./scripts/check-env.sh "<your name>" <M1|M2|M3>    # T1.4: paste the row into docs/environment.md
```

Then read, in order:
1. [docs/PROJECT_PLAN.md](docs/PROJECT_PLAN.md): Sections 1–3 (scope, architecture, stack) and your own tasks in Section 5
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

| Role | Member |
|---|---|
| M1 Application & Workload | _TBD at kickoff_ |
| M2 Automation & Platform | _TBD at kickoff_ |
| M3 Observability | _TBD at kickoff_ |
