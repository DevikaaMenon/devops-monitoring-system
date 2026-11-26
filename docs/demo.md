# Demo Script (about 20 minutes)

## Set-up (before faculty arrive, about 15 min)

1. Laptop plugged in; close unnecessary apps; `minikube status` shows Running.
2. Run `ansible-playbook teardown.yml` (namespaces only, cluster stays up, images stay cached) so that D1 deploys live in about 3–4 minutes.
3. **Terminal layout** (tmux or 3 windows, font size 16+):
   - **T1** command terminal at the repo root.
   - **T2** `watch -n1 kubectl get pods -n demo-app -o wide`
   - **T3** spare (logs, events).
4. **Browser tabs** (opened after D1): ① Grafana *Application Overview*, ② Grafana *Kubernetes Workloads*, ③ Grafana *Node & Platform*, ④ Prometheus `/targets`, ⑤ Prometheus `/alerts`, ⑥ App `http://<minikube-ip>:30080/`.
5. Backup video ready on the desktop. Slide with the architecture diagram open.

## Demonstration sequence

| Step | Presenter | Say (one line) | Command(s) | What should be visible on screen |
|---|---|---|---|---|
| **D0** Architecture (2 min) | Bhavana | "Five tools, one pipeline: code → image → cluster → metrics → dashboards, all deployed by Ansible." | (slide) | Architecture diagram from [overview.md](overview.md) |
| **D1** Ansible deploys the platform (4 min) | Devika | "One command creates every Kubernetes object from templates and variables, then verifies itself." | `cd ansible && ansible-playbook deploy.yml --ask-vault-pass` · meanwhile show `group_vars/all/vars.yml` and the encrypted `vault.yml` header | Tasks streaming; T2 shows pods appearing; final `verify` summary with 3 URLs; recap `failed=0` |
| **D1b** Idempotency (1 min) | Devika | "Run it again: nothing changes, because Ansible only acts when reality differs from the declared state." | `ansible-playbook deploy.yml --ask-vault-pass --tags cluster,app,monitoring` | Recap `changed=0` |
| **D2** The application (1 min) | Divyanth | "A small order API with business, health and failure endpoints." | `curl -s http://$(minikube ip):30080/ \| jq` · `curl -s -X POST -H 'Content-Type: application/json' -d '{"product":"book"}' http://$(minikube ip):30080/api/orders \| jq` | JSON with `version: 1.0.0` and a pod name; order created (201) |
| **D3** The Docker image (1 min) | Divyanth | "Built from a slim, non-root Dockerfile; same image on every laptop." | `docker images orders-api` · `cat app/Dockerfile` (scroll) · `minikube image ls \| grep orders` | Image tag `1.0.0`, ~150–200 MB; image present inside Minikube |
| **D4** Kubernetes objects (2 min) | Divyanth | "Two replicas behind a Service, with probes, limits and a quota." | `kubectl -n demo-app get deploy,rs,pods,svc,endpoints` · `kubectl -n demo-app describe pod -l app.kubernetes.io/name=orders-api \| grep -E 'Liveness\|Readiness\|Limits' -A2` · `for i in $(seq 10); do curl -s http://$(minikube ip):30080/ \| jq -r .pod; done \| sort \| uniq -c` | 2/2 pods; NodePort 30080; 2 endpoints; probe and limit lines; traffic split across both pods |
| **D5** Resource governance (30 s) | Devika | "The namespace is capped so it can't starve monitoring." | `kubectl -n demo-app describe quota` | Used vs Hard table (pods 3/10) |
| **D6** Prometheus collection (2 min) | Bhavana | "Prometheus discovers pods through the Kubernetes API. Nobody typed a pod IP anywhere." | Tab ④ Targets; expand `kubernetes-pods` and show labels · Graph tab: `sum(rate(http_requests_total[1m])) by (pod)` then `kube_deployment_status_replicas_available` · Tab ⑤ Alerts | 5 jobs all UP; 2 app pods with `pod`/`app` labels; per-pod graph; alerts green |
| **D7** Grafana (2 min) | Bhavana → Devika → Divyanth | "Application metrics vs infrastructure metrics: three dashboards, all provisioned from Git." | Tabs ① ② ③ | Live RED panels (rate, errors ≈ 0, p95); replicas 2/2, CPU/memory per pod; node gauges and targets table |
| **D8** Failure & recovery (3 min) | Divyanth | "Three failures, three different Kubernetes reactions, and one failure only monitoring can see." | (a) `./scripts/chaos.sh kill-pod` → watch T2 + tab ② · (b) `./scripts/chaos.sh break-liveness` → T2 RESTARTS column · (c) `./scripts/chaos.sh error-spike 0.5` → tab ① + tab ⑤ (narrate while waiting ~60–90 s) → `./scripts/chaos.sh heal` | (a) pod Terminating → new pod ContainerCreating → Running in ~10 s; *Healthy targets* 2→1→2; *Desired vs available* dip. (b) RESTARTS 0→1 after ~15–20 s; restart panel +1; `PodRestarted` firing. (c) pods stay Ready; error-ratio stat turns red (~25 %); 500s in the status panel; `OrdersApiHighErrorRate` Pending → Firing; after heal, the ratio returns to 0 |
| **D9** Scaling + monitoring reaction (2 min) | Bhavana | "Scale declaratively through Ansible; Prometheus picks up new pods automatically." | `ansible-playbook deploy.yml --ask-vault-pass --tags app,verify -e app_replicas=5` | T2: 3 new pods; tab ④: `kubernetes-pods (5/5 up)`; tab ①: *Request rate by pod* fans out to 5 lines; *Healthy targets* = 5; verify summary "replicas seen by Prometheus: 5" |
| **D9b** Quota limit + scale back (1 min) | Devika | "Scaling beyond the quota is refused, and monitoring shows it." | `kubectl -n demo-app scale deploy/orders-api --replicas=12` · `kubectl -n demo-app get events --sort-by=.lastTimestamp \| grep -i quota \| tail -2` · then `ansible-playbook deploy.yml --ask-vault-pass --tags app` | Only 9 app pods; `exceeded quota` event; tab ② desired 12 vs available 9. The Ansible run restores 2 (drift corrected) |
| **D10** Wrap-up (1 min) | All | "Limitations and next steps." | (slide) | Limitations / future work |

## If something goes wrong during the demo

| Problem | Quick recovery |
|---|---|
| D1 takes too long (slow network) | Switch to the recorded video of D1, then continue live on an already-deployed cluster (keep a second terminal with the platform pre-deployed on another laptop as a hot spare) |
| Grafana panel shows "No data" | Set the time range to *Last 5 minutes* and refresh. Check that loadgen is running: `kubectl -n demo-app get pods -l app.kubernetes.io/name=loadgen` |
| `minikube ip` unreachable | `minikube service grafana -n monitoring --url` (and the same for the others) |
| Cluster broken | `ansible-playbook teardown.yml -e full_teardown=true && ansible-playbook deploy.yml`. This is itself a demonstration of reproducibility, but it takes about 8 min, so use the backup video meanwhile |
