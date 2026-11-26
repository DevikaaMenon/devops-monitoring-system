# Tests

Record every result in `docs/TEST_REPORT.md` with columns: ID · Procedure · Expected · Actual · Pass/Fail · Evidence file · Tester · Date.

| ID | Area | Procedure | Expected result | Verification method |
|---|---|---|---|---|
| **TC-01** | App availability & unit tests | `cd app && pytest -v`; run locally, then `curl /`, `/health`, `/ready` | 6 tests pass; HTTP 200 on all three | pytest output; curl status codes |
| **TC-02** | Docker image build & run | `docker build -t orders-api:1.0.0 app/`; `docker run -d -p 8000:8000 …`; `docker exec … id`; inspect health | Build succeeds; image < 250 MB; container `healthy`; runs as uid 10001; `/metrics` reachable | `docker images`, `docker ps`, `docker inspect` |
| **TC-03** | Pod deployment | `kubectl -n demo-app get deploy,rs,pods` | Deployment `2/2` READY; pods `Running`, `1/1`, 0 restarts | kubectl output |
| **TC-04** | Service accessibility | `curl http://$(minikube ip):30080/` and `kubectl -n demo-app get endpoints orders-api` | HTTP 200 JSON with a pod name; 2 endpoint IPs | curl + endpoints output |
| **TC-05** | Multiple replicas & load balancing | 20× `curl …/ \| jq -r .pod \| sort \| uniq -c` | Both pod names appear, roughly evenly | Counted output |
| **TC-06** | Metrics exposure | `kubectl -n demo-app port-forward deploy/orders-api 8000:8000` then `curl localhost:8000/metrics` | All 6 contract metrics present with non-zero counters (loadgen running) | grep output |
| **TC-07** | Prometheus target discovery | Open `/targets` | Jobs `prometheus`, `kubernetes-pods` (2), `node-exporter` (1), `kube-state-metrics` (1), `kubernetes-cadvisor` (1), all **UP**; labels `pod`, `namespace`, `app` present | Screenshot; `curl -s $PROM/api/v1/targets \| jq '[.data.activeTargets[].health] \| unique'` → `["up"]` |
| **TC-08** | Metric collection | Run the 8 queries from T6.7; check *Status → Rules* | All return data; Q2 = 2; 3 recording + 4 alerting rules loaded | Screenshots; `docs/promql-validation.md` |
| **TC-09** | Grafana data source | *Save & test*; `curl -u … /api/datasources/uid/prometheus/health` | "Successfully queried the Prometheus API"; `status: OK` | Screenshot + curl |
| **TC-10** | Dashboard visualisation | Open each of the 3 dashboards with loadgen running for ≥ 5 min; delete the Grafana pod and reopen | Every panel shows data; dashboards come back after the pod restart (provisioned) | Screenshots before/after |
| **TC-11** | Alerting rules | `chaos.sh error-spike 0.5`, wait 90 s, then `chaos.sh heal` | `OrdersApiHighErrorRate` Inactive → Pending → Firing → resolved | Prometheus *Alerts* screenshots |
| **TC-12** | Failure & recovery | Scenarios S1, S2, S3 (task T10.1) | S1: replacement pod Ready in < 30 s. S2: RESTARTS = 1 within 30 s. S3: endpoint removed and then restored. Each change is visible on the dashboards | `kubectl get pods -w` log + Grafana screenshots; timings in `scenarios.md` |
| **TC-13** | Scale up / down | S5 then S6 (task T10.2) | 2→5→2 pods; `count(up{app="orders-api"})` follows within 30 s with no Prometheus config change; `verify` passes at 5 and at 2 | Grafana + Targets screenshots; verify recap |
| **TC-13b** | Resource governance | S8 (task T10.3) | Max 10 pods in namespace; `exceeded quota` event; Degraded alert fires | Events output + screenshot |
| **TC-14** | Ansible automated verification | `ansible-playbook verify.yml` | All tasks `ok`; `failed=0`; summary lists URLs and replicas = 2 | Recap screenshot |
| **TC-15** | Ansible repeatability & idempotency | (a) `install.yml` on 3 laptops; (b) `teardown.yml -e full_teardown=true` → `deploy.yml` → `deploy.yml` again | (a) all succeed; (b) first run builds a working platform; second run `changed=0` | Recaps; run times |
| **TC-16** | Ansible config management | Change `prometheus_scrape_interval` to `10s` → `deploy.yml --tags monitoring`; revert | Only the Prometheus ConfigMap + Deployment change; `/config` shows 10s; revert works | Recap + Prometheus Configuration page screenshot |

**Pass criterion for the project:** every TC passes on the demo laptop. TC-15(b) also passes on a second laptop.
