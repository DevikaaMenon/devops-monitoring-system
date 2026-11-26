# Project Plan

**Goal:** run a small web app on Kubernetes, monitor it with Prometheus and Grafana, and automate the whole setup with Ansible. The demo shows the app failing and scaling, with the dashboards reacting live.

The step-by-step instructions for every task (commands, files, how to check it worked) are in the [detailed plan](docs/reference/detailed-plan.md). Click any task ID below to jump to it.

## Team

| Name | Role | Owns |
|---|---|---|
| **Divyanth** | M1 · Application & Workload | The Flask app, its Docker image, its Kubernetes Deployment/Service, failure demos, *Application* dashboard |
| **Devika** | M2 · Automation & Platform | Ansible (laptop setup, cluster, playbooks), Grafana setup, quotas, kube-state-metrics, *Kubernetes* dashboard |
| **Bhavana** | M3 · Observability | Prometheus (config, auto-discovery, alerts), node-exporter, load generator, automatic checks, *Node* dashboard |

Everyone also writes one Ansible role, one Grafana dashboard, tests someone else's work, and writes part of the report. Planned effort: Divyanth ≈ 64 h · Devika ≈ 64 h · Bhavana ≈ 64 h. (The README task, T11.4, moved from Devika to Divyanth to balance this, because Devika already drafted the contract.)

## How to use this file

1. Find your name below and work through your list **top to bottom**.
2. When a task is finished and checked, tick its box (`[ ]` → `[x]`) **in the same PR** as the work.
3. Before starting, read your task in the detailed plan; it lists the exact files, commands and screenshots needed.
4. Stuck for more than an hour? Post it in the group and tag the person your task depends on.

## Milestones

| | Milestone | When | What "done" means | Status |
|---|---|---|---|---|
| 1 | **Kickoff** | Week 1 | Roles, dates and contract agreed | ⏳ roles agreed, meeting + contract approval pending |
| IM1 | **App on Kubernetes** | End of week 2 | App runs with 2 replicas on all 3 laptops | ⬜ |
| IM2 | **Metrics flowing** | Mid week 3 | Prometheus collects app + cluster metrics | ⬜ |
| IM3 | **Dashboards live** | End of week 3 | All 3 Grafana dashboards show live data | ⬜ |
| IM4 | **One command** | End of week 4 | `ansible-playbook deploy.yml` builds everything | ⬜ |
| IM5 | **Demo ready** | Mid week 5 | Full demo rehearsed in under 20 min | ⬜ |
| | **Submission** | Week 6 | Report, slides, video, repo tagged | ⬜ |

Update the Status column at each milestone: ⬜ not started · ⏳ in progress · ✅ done.

## Week by week


### Week 1: Plan agreed, laptops ready, app started

**Divyanth**

- [ ] [T1.1](docs/reference/detailed-plan.md#t11-kickoff-scope-freeze-and-working-agreement) Kickoff meeting: agree roles, scope, dates · 2 h
- [ ] [T1.4](docs/reference/detailed-plan.md#t14-laptop-readiness-check) Run the laptop readiness check · 1 h
- [ ] [T2.4](docs/reference/detailed-plan.md#t24-role-k8s_tools--installyml-rolled-out-to-all-three-laptops) Run `install.yml` on your laptop · 1 h
- [ ] [T3.1](docs/reference/detailed-plan.md#t31-flask-application-with-business-endpoints) Flask orders API · 4 h
- [ ] [T3.2](docs/reference/detailed-plan.md#t32-prometheus-instrumentation) Add Prometheus metrics to the app · 4 h
- [ ] [T3.3](docs/reference/detailed-plan.md#t33-health-readiness-and-failure-injection-endpoints) Health, readiness and failure endpoints · 3 h

**Devika**

- [ ] [T1.1](docs/reference/detailed-plan.md#t11-kickoff-scope-freeze-and-working-agreement) Kickoff meeting: agree roles, scope, dates · 2 h
- [x] [T1.3](docs/reference/detailed-plan.md#t13-repository-branching-and-folder-skeleton) Set up GitHub repo and folders · 2 h
- [x] [T1.4](docs/reference/detailed-plan.md#t14-laptop-readiness-check) Run the laptop readiness check · 1 h
- [ ] [T2.1](docs/reference/detailed-plan.md#t21-install-the-ansible-control-node-bootstrap) Install Ansible (bootstrap script) · 3 h
- [ ] [T2.2](docs/reference/detailed-plan.md#t22-ansible-project-config-inventory-variables-vault) Ansible config, inventory, variables, Vault · 3 h
- [ ] [T2.3](docs/reference/detailed-plan.md#t23-roles-common-and-docker) Ansible roles: base packages + Docker · 5 h
- [ ] [T2.4](docs/reference/detailed-plan.md#t24-role-k8s_tools--installyml-rolled-out-to-all-three-laptops) Ansible role: kubectl + Minikube (`install.yml`) · 4 h

**Bhavana**

- [ ] [T1.1](docs/reference/detailed-plan.md#t11-kickoff-scope-freeze-and-working-agreement) Kickoff meeting: agree roles, scope, dates · 2 h
- [ ] [T1.2](docs/reference/detailed-plan.md#t12-interface-contract-docscontractmd) Interface contract (names, ports, metrics) · 3 h · _drafted by Devika; Bhavana owns it from here (review, finalise, get approvals)_
- [ ] [T1.4](docs/reference/detailed-plan.md#t14-laptop-readiness-check) Run the laptop readiness check · 1 h
- [ ] [T2.4](docs/reference/detailed-plan.md#t24-role-k8s_tools--installyml-rolled-out-to-all-three-laptops) Run `install.yml` on your laptop · 1 h
- [ ] [T3.5](docs/reference/detailed-plan.md#t35-load-generator) Load generator script · 3 h


### Week 2: App running on Kubernetes (milestone IM1)

**Divyanth**

- [ ] [T3.4](docs/reference/detailed-plan.md#t34-unit-tests) Unit tests (pytest) · 3 h
- [ ] [T4.1](docs/reference/detailed-plan.md#t41-dockerfile-and-dockerignore) Dockerfile · 3 h
- [ ] [T4.2](docs/reference/detailed-plan.md#t42-build-run-and-verify-the-container-versioning-policy) Build and test the Docker image · 2 h
- [ ] [T4.3](docs/reference/detailed-plan.md#t43-load-the-image-into-minikube) Load the image into Minikube · 1 h
- [ ] [T5.2](docs/reference/detailed-plan.md#t52-namespaces-and-app-configmap) Namespace + ConfigMap · 1 h
- [ ] [T5.3](docs/reference/detailed-plan.md#t53-deployment-with-replicas-probes-resources-and-rolling-update) Deployment (2 replicas, probes, limits) · 4 h
- [ ] [T5.4](docs/reference/detailed-plan.md#t54-service-and-access-verification) Service (NodePort 30080) · 2 h

**Devika**

- [ ] [T5.1](docs/reference/detailed-plan.md#t51-start-and-verify-the-minikube-cluster-manual) Start the Minikube cluster · 2 h
- [ ] [T5.6](docs/reference/detailed-plan.md#t56-namespace-resource-management-limitrange--resourcequota) LimitRange + ResourceQuota · 2 h
- [ ] [T6.5](docs/reference/detailed-plan.md#t65-kube-state-metrics) kube-state-metrics (Kubernetes metrics) · 3 h

**Bhavana**

- [ ] [T5.5](docs/reference/detailed-plan.md#t55-load-generator-inside-the-cluster) Load generator running in the cluster · 2 h
- [ ] [T6.1](docs/reference/detailed-plan.md#t61-monitoring-namespace-and-prometheus-rbac) Monitoring namespace + Prometheus permissions · 2 h
- [ ] [T6.2](docs/reference/detailed-plan.md#t62-prometheus-configuration-scrape-jobs--service-discovery) Prometheus config (auto-discovery of pods) · 5 h
- [ ] [T6.3](docs/reference/detailed-plan.md#t63-prometheus-deployment-and-service) Deploy Prometheus · 3 h
- [ ] [T6.4](docs/reference/detailed-plan.md#t64-node-exporter-daemonset) node-exporter (node metrics) · 2 h


### Week 3: Metrics in Prometheus (IM2) and dashboards in Grafana (IM3)

**Divyanth**

- [ ] [T7.3](docs/reference/detailed-plan.md#t73--t74--t75-the-three-dashboards-one-per-member) Dashboard: Application Overview · 5 h

**Devika**

- [ ] [T7.1](docs/reference/detailed-plan.md#t71-grafana-secret-deployment-and-service) Deploy Grafana · 3 h
- [ ] [T7.2](docs/reference/detailed-plan.md#t72-data-source-and-dashboard-provisioning) Connect Grafana to Prometheus + load dashboards from Git · 3 h
- [ ] [T7.3](docs/reference/detailed-plan.md#t73--t74--t75-the-three-dashboards-one-per-member) Dashboard: Application Overview · 3 h
- [ ] [T7.4](docs/reference/detailed-plan.md#t73--t74--t75-the-three-dashboards-one-per-member) Dashboard: Kubernetes Workloads · 4 h

**Bhavana**

- [ ] [T6.6](docs/reference/detailed-plan.md#t66-alert-and-recording-rules) Alert rules · 3 h
- [ ] [T6.7](docs/reference/detailed-plan.md#t67-validate-targets-and-key-promql-queries) Check all targets and queries work · 2 h
- [ ] [T7.5](docs/reference/detailed-plan.md#t73--t74--t75-the-three-dashboards-one-per-member) Dashboard: Node & Platform · 4 h


### Week 4: Everything deploys with one Ansible command (IM4)

**Divyanth**

- [ ] [T8.2](docs/reference/detailed-plan.md#t82-role-app_deploy) Ansible role: build + deploy the app · 6 h
- [ ] [T8.6](docs/reference/detailed-plan.md#t86-clean-rebuild-and-idempotency-test-on-a-second-laptop) Rebuild from scratch on your laptop + idempotency test · 2 h

**Devika**

- [ ] [T8.1](docs/reference/detailed-plan.md#t81-role-minikube_cluster) Ansible role: start/configure Minikube · 4 h
- [ ] [T8.4](docs/reference/detailed-plan.md#t84-playbooks-deployyml-siteyml-teardownyml) Playbooks: deploy, site, teardown · 3 h

**Bhavana**

- [ ] [T8.3](docs/reference/detailed-plan.md#t83-role-monitoring) Ansible role: deploy monitoring · 6 h
- [ ] [T8.5](docs/reference/detailed-plan.md#t85-verifyyml-and-role-verify-automated-smoke-tests) Ansible role: automatic checks (`verify.yml`) · 3 h


### Week 5: Testing + failure/scaling demos + first rehearsal (IM5)

**Divyanth**

- [ ] [T9.3](docs/reference/detailed-plan.md#phase-9-testing-and-validation) Test Devika's + Bhavana's monitoring work (TC-07–11) · 3 h
- [ ] [T10.1](docs/reference/detailed-plan.md#t101-failure-injection-script-and-scenarios) Failure demos (kill pod, liveness, errors) · 3 h
- [ ] [T10.4](docs/reference/detailed-plan.md#t104-demo-runbook-and-rehearsals) Demo runbook + 2 rehearsals · 3 h
- [ ] [T11.4](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) README (how to run it) · 2 h

**Devika**

- [ ] [T9.2](docs/reference/detailed-plan.md#phase-9-testing-and-validation) Test Divyanth's work (TC-01–06) · 3 h
- [ ] [T10.3](docs/reference/detailed-plan.md#t103-resource-governance-scenarios) Quota + CPU pressure demos · 2 h
- [ ] [T10.4](docs/reference/detailed-plan.md#t104-demo-runbook-and-rehearsals) Demo runbook + 2 rehearsals · 3 h

**Bhavana**

- [ ] [T9.1](docs/reference/detailed-plan.md#phase-9-testing-and-validation) Write the test plan / report template · 2 h
- [ ] [T9.4](docs/reference/detailed-plan.md#phase-9-testing-and-validation) Test the Ansible automation (TC-14–16) · 2 h
- [ ] [T10.2](docs/reference/detailed-plan.md#t102-scaling-scenarios-imperative-vs-declarative) Scaling demos (2 → 5 → 2) · 3 h
- [ ] [T10.4](docs/reference/detailed-plan.md#t104-demo-runbook-and-rehearsals) Demo runbook + 2 rehearsals · 3 h
- [ ] [T11.1](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Architecture diagrams · 3 h


### Week 6: Report, slides, final rehearsals, submit

**Divyanth**

- [ ] [T5.7](docs/reference/detailed-plan.md#t57-optional-horizontal-pod-autoscaler) (Optional) Autoscaler (HPA) · 2 h
- [ ] [T11.2](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Your report sections · 6 h
- [ ] [T11.3](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Your slides · 2 h
- [ ] [T11.5](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Collect your screenshots · 1 h

**Devika**

- [ ] [T11.2](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Your report sections · 6 h
- [ ] [T11.3](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Your slides · 2 h
- [ ] [T11.5](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Collect your screenshots · 1 h

**Bhavana**

- [ ] [T11.2](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Your report sections · 6 h
- [ ] [T11.3](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Your slides · 2 h
- [ ] [T11.5](docs/reference/detailed-plan.md#phase-11-documentation-diagrams-and-presentation) Collect your screenshots · 1 h

## Who depends on whom

| You need… | From | Before you can… |
|---|---|---|
| Laptop with Docker, kubectl, Minikube (T2.4) | Devika | build the image (Divyanth), deploy Prometheus (Bhavana) |
| The contract approved (T1.2) | Bhavana | start the app (Divyanth) or the Prometheus config (Bhavana) |
| App pods running with metrics (T5.3) | Divyanth | check Prometheus picks them up (Bhavana) |
| Working PromQL queries (T6.7) | Bhavana | build the dashboards (all) |
| Grafana connected to Prometheus (T7.2) | Devika | save dashboards (all) |
| `group_vars` variable names (T2.2) | Devika | write your Ansible role (Divyanth, Bhavana) |

## Rules (short version)

- Never push to `main`. Use a branch (`feature/t3.1-flask-app`) and open a PR.
- Someone who **doesn't** own the task reviews it and runs it on their own laptop.
- Don't rename anything in [docs/CONTRACT.md](docs/CONTRACT.md) without all three agreeing.
- No `latest` image tags, no passwords in Git.
- Save a screenshot of each finished task in `docs/screenshots/<TaskID>-<name>.png`.

Full rules: [CONTRIBUTING.md](CONTRIBUTING.md).

## Where things are

| Need | File |
|---|---|
| Exact steps for a task | [docs/reference/detailed-plan.md](docs/reference/detailed-plan.md) |
| Names, ports, metric names | [docs/CONTRACT.md](docs/CONTRACT.md) (in PR #1 until approved) |
| Everyone's laptop specs | [docs/environment.md](docs/environment.md) |
| All tasks as a spreadsheet | [docs/tasks.csv](docs/tasks.csv) |
| Test cases and the demo script | Sections 8 and 9 of the detailed plan |
