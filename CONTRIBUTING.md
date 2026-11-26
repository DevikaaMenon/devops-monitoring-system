# How We Work

## Rules

1. Don't push to `main`. Make a branch, then open a pull request.
2. Someone who didn't write it reviews it and runs it on their own laptop before approving.
3. Don't rename anything in [docs/CONTRACT.md](docs/CONTRACT.md) unless all three agree.
4. Don't use `latest` image tags, and don't commit passwords.
5. Tick your task in [PLAN.md](PLAN.md) in the same pull request.

## Each task

```bash
git switch main && git pull
git switch -c t3.1-flask-app          # branch name = task ID + short name
# ...work, commit...
git push -u origin t3.1-flask-app
gh pr create --fill                   # or open the PR on github.com
```

Commit messages start with the task ID, for example `T3.1: add orders endpoint`.

## Who owns what

If you need to change someone else's files, ask them to review your PR.

| Person | Files |
|---|---|
| Divyanth | `app/`, `k8s/app/` (except quota and loadgen), `ansible/roles/app_deploy/`, `app-overview.json`, `scripts/chaos.sh`, `README.md` |
| Devika | `ansible/` (except the two roles below), `scripts/bootstrap.sh`, quota, kube-state-metrics, Grafana files, `k8s-workloads.json` |
| Bhavana | `docs/CONTRACT.md`, Prometheus + node-exporter files, loadgen, `ansible/roles/monitoring/` + `verify/`, `node-platform.json`, test report, diagrams |
