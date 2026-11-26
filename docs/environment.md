# Team Environments (T1.4)

Each member runs `./scripts/check-env.sh "<name>" <M1|M2|M3>` on their own laptop and pastes the printed row below.

Requirements (plan Section 3.1): Ubuntu 22.04/24.04 · ≥ 4 cores · ≥ 8 GiB RAM (16 recommended) · ≥ 25 GiB free disk · Python ≥ 3.12.
The last column is the Minikube sizing that member should use (`minikube_cpus` / `minikube_memory_mb`).

| Member | Role | OS | CPUs | RAM | Free disk | VT-x/AMD-V | Python | Docker | kubectl | Minikube | Minikube CPU / MB | Checked |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Devika | M2 | Ubuntu 24.04.5 LTS | 16 | 23 GiB | 138 GiB | yes | 3.12 | 29.8.1 | v1.37.2 | v1.39.0 | 4 / 6144 | 2026-11-26 |
| Divyanth | M1 | _not run yet_ | | | | | | | | | | |
| Bhavana | M3 | _not run yet_ | | | | | | | | | | |

## Notes

- Devika's laptop already has Docker CE 29.8.1 (from Docker's apt repo), kubectl v1.37.2 and Minikube v1.39.0. These match the contract, so the Phase 2 roles should report them as `ok`. Ansible is not installed yet (Phase 2, T2.1). An old Minikube profile exists in a stopped state. Run `minikube delete` before T5.1 so the cluster starts fresh with the pinned Kubernetes version.
