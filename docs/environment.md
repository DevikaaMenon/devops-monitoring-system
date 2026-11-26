# Laptops

Run `./scripts/check-env.sh "<name>" <M1|M2|M3>` and paste the row it prints.

| Name | Role | OS | CPUs | RAM | Free disk | VT-x/AMD-V | Python | Docker | kubectl | Minikube | Minikube CPU / MB | Checked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Devika | M2 | Ubuntu 24.04.5 LTS | 16 | 23 GiB | 138 GiB | yes | 3.12 | 29.8.1 | v1.37.2 | v1.39.0 | 4 / 6144 | 2026-11-26 |
| Divyanth | M1 | _not run yet_ | | | | | | | | | | |
| Bhavana | M3 | _not run yet_ | | | | | | | | | | |

**Note for Devika:** Docker, kubectl and Minikube are already installed at the right versions. Run `minikube delete` before task T5.1 to remove the old cluster.
