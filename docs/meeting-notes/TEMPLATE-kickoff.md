# Kickoff Meeting (T1.1)

Copy this file to `YYYY-MM-DD-kickoff.md`, fill it in during the meeting, and commit it.

**Date:**
**Attendees:**

## 1. Roles (plan Section 5)

| Role | Member |
|---|---|
| M1 Application & Workload | |
| M2 Automation & Platform | |
| M3 Observability | |

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
- Approved by: ☐ M1 ☐ M2 ☐ M3

## 6. Actions

| Action | Owner | Due |
|---|---|---|
| Run `scripts/check-env.sh` and add the row to `docs/environment.md` | All | |
| Accept GitHub invite; confirm `git clone` works | M1, M3 | |
| Create issues + project board (`scripts/create-issues.py --apply`) | M2 | |
| Start T2.1 (bootstrap Ansible) | M2 | |
| Start T3.1 (Flask app) | M1 | |
| Start T3.5 (local loadgen) | M3 | |

## Sign-off

☐ M1 ☐ M2 ☐ M3
