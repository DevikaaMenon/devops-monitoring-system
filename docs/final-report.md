# Final Report and Submission

## Report sections and owners

Each member writes roughly a third, and **each writes the implementation section for their own components** so the report reflects who built what.

| # | Section | Owner | Contents / source material |
|---|---|---|---|
| 1 | Title page, abstract (150–200 words) | Bhavana | Problem, approach, tools, outcome (written last) |
| 2 | Problem statement | Divyanth | overview.md, expanded with a real-world motivation |
| 3 | Objectives | Devika | overview.md goals as measurable objectives (link each to a test case) |
| 4 | Requirements (functional, non-functional, hardware/software) | Devika | overview.md |
| 5 | Architecture: high-level, component, sequence, Ansible flow diagrams + explanation | Bhavana | overview.md + T11.1 diagrams |
| 6 | Technology descriptions (Docker, Kubernetes, Ansible, Prometheus, Grafana) + application vs infrastructure metrics | Divyanth (Docker, K8s), Devika (Ansible, Grafana), Bhavana (Prometheus, metrics types) | overview.md |
| 7.1 | Implementation: application, instrumentation, Dockerfile | Divyanth | `app/`, T3.x, T4.x |
| 7.2 | Implementation: Kubernetes workload (Deployment, Service, probes, rolling update) | Divyanth | `k8s/app/` |
| 7.3 | Implementation: Ansible project (inventory, vars, Vault, roles, playbooks, idempotency) | Devika | `ansible/` (each role's README by its owner) |
| 7.4 | Implementation: resource governance, kube-state-metrics, Grafana provisioning | Devika | T5.6, T6.5, T7.1–7.2 |
| 7.5 | Implementation: Prometheus (SD, relabeling, jobs, rules), node-exporter, loadgen | Bhavana | `k8s/monitoring/`, T6.x |
| 7.6 | Implementation: dashboards (one subsection per dashboard, by its owner) | Divyanth, Devika, Bhavana | `grafana/dashboards/` + screenshots |
| 8 | Appendix A: Dockerfile; B: Kubernetes manifests; C: Ansible inventory, vars (Vault redacted), playbooks, roles; D: `prometheus.yml` + rules; E: dashboard panel/query tables | Owners of each file | Copy from repo (or link to a tagged release) |
| 9 | Testing & results (TC-01…16 table + evidence) | Bhavana (compiles), each tester's rows | `docs/TEST_REPORT.md` |
| 10 | Failure, scaling & recovery analysis (S1–S9 with timings and graphs) | Divyanth (S1–S4), Bhavana (S5–S7), Devika (S8–S9) | `docs/scenarios.md` |
| 11 | Screenshots (labelled with task/test IDs) | Each for their own | `docs/screenshots/` |
| 12 | Limitations | Divyanth | See below |
| 13 | Future enhancements | Devika | See below |
| 14 | Conclusion | Bhavana | Objectives → evidence mapping |
| 15 | References (official docs, versions) | All | Kubernetes, Prometheus, Grafana, Ansible docs |
| 16 | Individual contribution statement + Git stats (`git shortlog -sn`) | All | PLAN.md + actual hours |

**Submission bundle:**
- [ ] Git repository (tag `v1.0-final`) with `README.md` quick start
- [ ] `docs/report.pdf`
- [ ] `docs/presentation.pdf`
- [ ] `docs/TEST_REPORT.md` with evidence links
- [ ] `docs/diagrams/` (source + PNG)
- [ ] `docs/screenshots/` (≥ 1 per test case)
- [ ] `grafana/dashboards/*.json` (3 files)
- [ ] Backup demo video (MP4, ≤ 10 min)
- [ ] Vault password **not** in the repo (handed to the examiner separately if required)

## Limitations and future enhancements (draft content)

**Limitations (be honest about these):**
- Single-node local cluster, so no node-failure scenario and no real high availability.
- Prometheus and Grafana use `emptyDir`, so metric history is lost when their pod restarts. Dashboards survive because they are provisioned.
- Admin/failure endpoints have no authentication. They are for demos only.
- No alert notifications (alerts are visible in Prometheus only).
- With the Docker driver, node-exporter reports largely host-level figures.
- In-memory order store, so data is lost on restart and each replica has its own store (stateless demo).
- Passwords are in a Vault file, but the cluster stores Secrets base64-encoded, not encrypted at rest.

**Future enhancements:** Alertmanager + email/Slack; PersistentVolumes; HPA on custom metrics (prometheus-adapter); Ingress + TLS; Loki for logs; OpenTelemetry tracing; a multi-node cluster (kubeadm on VMs provisioned by the same Ansible roles); a CI pipeline (lint, test, build) once the project scope allows; GitOps (Argo CD).

## Viva question bank (every member must answer all of these)

1. What is the difference between a liveness and a readiness probe? Which one did `chaos.sh unready` trigger, and why was the pod not restarted?
2. Why did Kubernetes not react to the 50 % error rate? What did?
3. How does Prometheus find a new pod? Walk through the relabel rules.
4. Why a counter plus `rate()` instead of a gauge for request counts? What does `histogram_quantile` need?
5. Why only one gunicorn worker per container?
6. What makes your Ansible run idempotent? Show a task that would *not* be idempotent without `changed_when`.
7. Why does changing the ConfigMap restart the pods in your setup? (checksum annotation)
8. What is the difference between `kubectl scale` and changing `app_replicas`? What happened on the next Ansible run?
9. Where do application metrics vs infrastructure metrics come from in your stack? Name one of each from each source.
10. What happens to metric history if the Prometheus pod restarts? How would you fix that?
11. Why is the Grafana password not in Git, and how does it get into the cluster?
12. Why use `minikube image load` and `imagePullPolicy: IfNotPresent`?


## Definition of Done

The project is **complete** only when **all** of the following are true and evidenced.

**Functional**
1. On a fresh Ubuntu laptop, `scripts/bootstrap.sh` → `ansible-playbook install.yml -K` → re-login → `ansible-playbook deploy.yml` produces a working platform with **no manual `kubectl` or `docker` commands**.
2. `ansible-playbook verify.yml` passes: app `/health` 200; all Prometheus targets `up`; Prometheus sees exactly `app_replicas` app pods; the Grafana data source is `OK`; 3 dashboards are provisioned.
3. A second `deploy.yml` run reports `changed=0, failed=0`.
4. `orders-api` runs with 2 replicas behind a NodePort Service, with liveness/readiness probes, requests/limits, a rolling-update strategy, LimitRange and ResourceQuota.
5. Prometheus scrapes 5 jobs (`prometheus`, `kubernetes-pods`, `node-exporter`, `kube-state-metrics`, `kubernetes-cadvisor`) via Kubernetes SD, with 3 recording and 4 alert rules loaded.
6. All three Grafana dashboards show live data on every panel and survive a Grafana pod deletion.
7. Scenarios S1 (pod kill), S2 (liveness restart), S4 (error spike → alert fires), S5/S6 (scale 2→5→2 with automatic discovery) and S8 (quota) behave as specified and are visible on the dashboards.

**Quality**
8. All 17 test cases (TC-01 … TC-16 plus TC-13b) are **Pass** in `docs/TEST_REPORT.md`, each with evidence.
9. `pytest`, `yamllint`, `ansible-lint` (no errors) and `promtool check config/rules` all pass.
10. No `latest` tags; all versions pinned in `group_vars` / the contract; no secrets in Git (`git log -p | grep -i password` shows only Vault ciphertext or variable names).

**Team & submission**
11. Every member has merged commits in Docker/K8s YAML, an Ansible role, a Grafana dashboard and at least one test-execution task (`git shortlog -sn` and the PR history show this).
12. The demo runbook has been rehearsed twice, under 20 minutes, and a backup video exists.
13. The report (all 16 sections), slides, diagrams and README are submitted, and every member can answer the viva questions above about the *whole* system.
