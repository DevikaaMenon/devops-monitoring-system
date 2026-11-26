# Kickoff Meeting (T1.1)

Copy this file to `YYYY-MM-DD-kickoff.md`, fill it in during the meeting, and commit it.

**Date:**
**Attendees:**

## 1. Roles (plan Section 5)

| Role | Member |
|---|---|
| M1 Application & Workload | Divyanth |
| M2 Automation & Platform | Devika |
| M3 Observability | Bhavana |

## 2. Scope freeze (plan Section 1.7)

- [ ] All mandatory items accepted as-is
- Changes to the mandatory list (if any):
- Optional items we will consider **only after IM5** (tick at most two):
  - [ ] HPA · [ ] Alertmanager · [ ] Prometheus PVC · [ ] Ingress · [ ] Vagrant VM target · [ ] second microservice

## 3. Timeline

- Project duration: ☐ 6 weeks ☐ 4 weeks (compressed plan, Section 7)
- Submission date:
- Demo date:
- Milestone dates: IM1 ___ · IM2 ___ · IM3 ___ · IM4 ___ · IM5 ___

## 4. Working agreement

- [ ] `CONTRIBUTING.md` reviewed and accepted (branches, PR review, file ownership)
- Sync days/times: ___ and ___ (30 min)
- Communication channel:
- Vault password will be shared via:

## 5. Interface contract

- [ ] `docs/CONTRACT.md` walked through together
- Requested changes:
- Approved by: ☐ Divyanth ☐ Devika ☐ Bhavana

## 6. Actions

| Action | Owner | Due |
|---|---|---|
| Run `scripts/check-env.sh` and add the row to `docs/environment.md` | Divyanth, Bhavana | |
| Accept GitHub invite; confirm `git clone` works | Divyanth, Bhavana | |
| Review/finalise the contract (PR #1) and collect approvals | Bhavana | |
| Create issues + project board (`scripts/create-issues.py --apply`) | Devika | |
| Start T2.1 (bootstrap Ansible) | Devika | |
| Start T3.1 (Flask app) | Divyanth | |
| Start T3.5 (local loadgen) | Bhavana | |

## Sign-off

☐ Divyanth ☐ Devika ☐ Bhavana
