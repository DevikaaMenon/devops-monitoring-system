# Plan

Tick a box (`[ ]` → `[x]`) in the same pull request as the finished work. Click a task ID for its exact steps.

| Name | Role | Owns |
|---|---|---|
| **Divyanth** | M1 · App | The app, its Docker image and Kubernetes setup, failure demos |
| **Devika** | M2 · Automation | Ansible, the cluster, Grafana setup, quotas |
| **Bhavana** | M3 · Monitoring | Prometheus, alerts, exporters, load generator, automatic checks |

Each person also builds one Grafana dashboard and one Ansible role, and tests someone else's work. That's about 64 hours each.

## Milestones

| Week | Milestone | Status |
|---|---|---|
| 1 | Kickoff done, laptops set up | ⏳ |
| 2 | App running on Kubernetes | ⬜ |
| 3 | Metrics in Prometheus, dashboards in Grafana | ⬜ |
| 4 | Everything deploys with one Ansible command | ⬜ |
| 5 | Tests passed, demo rehearsed | ⬜ |
| 6 | Report, slides and submission | ⬜ |

⬜ not started · ⏳ in progress · ✅ done

## Divyanth

**Week 1**
- [ ] [T2.4](docs/guide.md#t24-role-k8s_tools--installyml-rolled-out-to-all-three-laptops) Run Devika's `install.yml` on your laptop · 1 h
- [ ] [T3.1](docs/guide.md#t31-flask-application-with-business-endpoints) Flask orders API · 4 h
- [ ] [T3.2](docs/guide.md#t32-prometheus-instrumentation) Add metrics to the app · 4 h
- [ ] [T3.3](docs/guide.md#t33-health-readiness-and-failure-injection-endpoints) Health and failure endpoints · 3 h

**Week 2**
- [ ] [T3.4](docs/guide.md#t34-unit-tests) Unit tests · 3 h
- [ ] [T4.1](docs/guide.md#t41-dockerfile-and-dockerignore) Dockerfile · 3 h
- [ ] [T4.2](docs/guide.md#t42-build-run-and-verify-the-container-versioning-policy) Build and test the image · 2 h
- [ ] [T4.3](docs/guide.md#t43-load-the-image-into-minikube) Load the image into Minikube · 1 h
- [ ] [T5.2](docs/guide.md#t52-namespaces-and-app-configmap) Namespace + ConfigMap · 1 h
- [ ] [T5.3](docs/guide.md#t53-deployment-with-replicas-probes-resources-and-rolling-update) Deployment (2 replicas) · 4 h
- [ ] [T5.4](docs/guide.md#t54-service-and-access-verification) Service · 2 h

**Week 3**
- [ ] [T7.3](docs/guide.md#t73--t74--t75-the-three-dashboards-one-per-member) Application dashboard · 5 h

**Week 4**
- [ ] [T8.2](docs/guide.md#t82-role-app_deploy) Ansible role: deploy app · 6 h
- [ ] [T8.6](docs/guide.md#t86-clean-rebuild-and-idempotency-test-on-a-second-laptop) Rebuild everything from scratch on your laptop · 2 h

**Week 5**
- [ ] [T9.3](docs/guide.md#phase-9-testing-and-validation) Test the monitoring (TC-07–11) · 3 h
- [ ] [T10.1](docs/guide.md#t101-failure-injection-script-and-scenarios) Failure demos · 3 h
- [ ] [T11.4](docs/guide.md#phase-11-documentation-diagrams-and-presentation) README · 2 h

**Week 6**
- [ ] [T5.7](docs/guide.md#t57-optional-horizontal-pod-autoscaler) Autoscaler (optional) · 2 h

## Devika

**Week 1**
- [x] [T1.3](docs/guide.md#t13-repository-branching-and-folder-skeleton) Set up GitHub repo · 2 h
- [ ] [T2.1](docs/guide.md#t21-install-the-ansible-control-node-bootstrap) Install Ansible · 3 h
- [ ] [T2.2](docs/guide.md#t22-ansible-project-config-inventory-variables-vault) Ansible config, inventory, variables, Vault · 3 h
- [ ] [T2.3](docs/guide.md#t23-roles-common-and-docker) Ansible: install Docker · 5 h
- [ ] [T2.4](docs/guide.md#t24-role-k8s_tools--installyml-rolled-out-to-all-three-laptops) Ansible: install kubectl + Minikube · 4 h

**Week 2**
- [ ] [T5.1](docs/guide.md#t51-start-and-verify-the-minikube-cluster-manual) Start Minikube · 2 h
- [ ] [T5.6](docs/guide.md#t56-namespace-resource-management-limitrange--resourcequota) Quota and limits · 2 h
- [ ] [T6.5](docs/guide.md#t65-kube-state-metrics) kube-state-metrics · 3 h

**Week 3**
- [ ] [T7.1](docs/guide.md#t71-grafana-secret-deployment-and-service) Deploy Grafana · 3 h
- [ ] [T7.2](docs/guide.md#t72-data-source-and-dashboard-provisioning) Connect Grafana to Prometheus · 3 h
- [ ] [T7.3](docs/guide.md#t73--t74--t75-the-three-dashboards-one-per-member) Application dashboard · 3 h
- [ ] [T7.4](docs/guide.md#t73--t74--t75-the-three-dashboards-one-per-member) Kubernetes dashboard · 4 h

**Week 4**
- [ ] [T8.1](docs/guide.md#t81-role-minikube_cluster) Ansible role: Minikube · 4 h
- [ ] [T8.4](docs/guide.md#t84-playbooks-deployyml-siteyml-teardownyml) Ansible playbooks · 3 h

**Week 5**
- [ ] [T9.2](docs/guide.md#phase-9-testing-and-validation) Test the app and Kubernetes setup (TC-01–06) · 3 h
- [ ] [T10.3](docs/guide.md#t103-resource-governance-scenarios) Quota and CPU demos · 2 h

## Bhavana

**Week 1**
- [ ] [T1.2](docs/guide.md#t12-interface-contract-docscontractmd) Interface contract (names, ports, metrics) · 3 h · _drafted by Devika, Bhavana finalises it_
- [ ] [T2.4](docs/guide.md#t24-role-k8s_tools--installyml-rolled-out-to-all-three-laptops) Run Devika's `install.yml` on your laptop · 1 h
- [ ] [T3.5](docs/guide.md#t35-load-generator) Load generator script · 3 h

**Week 2**
- [ ] [T5.5](docs/guide.md#t55-load-generator-inside-the-cluster) Load generator in the cluster · 2 h
- [ ] [T6.1](docs/guide.md#t61-monitoring-namespace-and-prometheus-rbac) Prometheus permissions · 2 h
- [ ] [T6.2](docs/guide.md#t62-prometheus-configuration-scrape-jobs--service-discovery) Prometheus config · 5 h
- [ ] [T6.3](docs/guide.md#t63-prometheus-deployment-and-service) Deploy Prometheus · 3 h
- [ ] [T6.4](docs/guide.md#t64-node-exporter-daemonset) node-exporter · 2 h

**Week 3**
- [ ] [T6.6](docs/guide.md#t66-alert-and-recording-rules) Alert rules · 3 h
- [ ] [T6.7](docs/guide.md#t67-validate-targets-and-key-promql-queries) Check all metrics arrive · 2 h
- [ ] [T7.5](docs/guide.md#t73--t74--t75-the-three-dashboards-one-per-member) Node dashboard · 4 h

**Week 4**
- [ ] [T8.3](docs/guide.md#t83-role-monitoring) Ansible role: deploy monitoring · 6 h
- [ ] [T8.5](docs/guide.md#t85-verifyyml-and-role-verify-automated-smoke-tests) Ansible role: automatic checks · 3 h

**Week 5**
- [ ] [T9.1](docs/guide.md#phase-9-testing-and-validation) Test plan · 2 h
- [ ] [T9.4](docs/guide.md#phase-9-testing-and-validation) Test the Ansible automation (TC-14–16) · 2 h
- [ ] [T10.2](docs/guide.md#t102-scaling-scenarios-imperative-vs-declarative) Scaling demos · 3 h
- [ ] [T11.1](docs/guide.md#phase-11-documentation-diagrams-and-presentation) Architecture diagrams · 3 h

## Everyone

- [ ] [T1.1](docs/guide.md#t11-kickoff-scope-freeze-and-working-agreement) Kickoff meeting · 2 h · week 1
- [ ] [T1.4](docs/guide.md#t14-laptop-readiness-check) Run `scripts/check-env.sh` · 1 h · _Devika ✓ · Divyanth ☐ · Bhavana ☐_
- [ ] [T10.4](docs/guide.md#t104-demo-runbook-and-rehearsals) Rehearse the demo twice · 3 h · week 5
- [ ] [T11.2](docs/guide.md#phase-11-documentation-diagrams-and-presentation) Your report sections · 6 h · week 6
- [ ] [T11.3](docs/guide.md#phase-11-documentation-diagrams-and-presentation) Your slides · 2 h · week 6
- [ ] [T11.5](docs/guide.md#phase-11-documentation-diagrams-and-presentation) Your screenshots · 1 h · week 6

## Other docs

- [docs/overview.md](docs/overview.md): what we're building and why
- [docs/guide.md](docs/guide.md): exact steps for every task
- [docs/CONTRACT.md](docs/CONTRACT.md): names, ports and metrics everyone must use
- [docs/testing.md](docs/testing.md): the test cases
- [docs/demo.md](docs/demo.md): the demo script
- [docs/final-report.md](docs/final-report.md): report checklist and when we're done
