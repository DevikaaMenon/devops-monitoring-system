## Task

Closes #<!-- issue number -->. Task ID: <!-- e.g. T3.2 -->

## What changed

<!-- 2–5 bullet points -->

## How I verified it

<!-- Commands you ran and what you saw. Link screenshots in docs/screenshots/<TaskID>-*.png -->

## Checklist

- [ ] Follows `docs/CONTRACT.md` (names, labels, ports, metric names unchanged)
- [ ] No `latest` image tags; versions match the contract
- [ ] No secrets in plain text (Grafana password only in the Vault file)
- [ ] Linters pass where relevant: `yamllint k8s/ ansible/` · `ansible-lint ansible/` · `pytest app/` · `promtool check …`
- [ ] Evidence screenshot saved (if the plan asks for one)

## Reviewer (a member who does not own this component)

- [ ] I ran it locally and it works as described
