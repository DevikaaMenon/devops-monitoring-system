# DevOps Monitoring Platform

A web app running on Kubernetes, monitored with Prometheus and Grafana, set up automatically with Ansible.

**Team:** Divyanth (app) · Devika (automation) · Bhavana (monitoring)

**Status:** planning done. Building starts in week 1.

## Start here

1. Read [PLAN.md](PLAN.md) and find your name.
2. Check your laptop:
   ```bash
   git clone https://github.com/DevikaaMenon/devops-monitoring-system.git
   cd devops-monitoring-system
   ./scripts/check-env.sh "<your name>" <M1|M2|M3>
   ```
3. Read [CONTRIBUTING.md](CONTRIBUTING.md) (one page) before your first pull request.

## Run it (after week 4)

```bash
./scripts/bootstrap.sh                          # once: installs Ansible
cd ansible
ansible-playbook install.yml -K                 # once: Docker, kubectl, Minikube (log out and in afterwards)
ansible-playbook deploy.yml --ask-vault-pass    # deploys everything and checks it
```

Then open `http://$(minikube ip):30030` for Grafana, `:30090` for Prometheus and `:30080` for the app.
