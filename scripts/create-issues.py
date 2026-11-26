#!/usr/bin/env python3
"""T1.1 step 5: create one GitHub issue per task from docs/tasks.csv.

Usage (from the repo root, after `gh auth login` and pushing the repo):
    python3 scripts/create-issues.py            # dry run: prints what it would create
    python3 scripts/create-issues.py --apply    # creates labels + issues

Issues that already exist (same "Txx.y:" title prefix) are skipped, so re-running is safe.
Add the issues to a GitHub Projects board afterwards (Projects -> Add items -> filter by repo).
"""
import csv
import json
import subprocess
import sys
from pathlib import Path

APPLY = "--apply" in sys.argv
ROOT = Path(__file__).resolve().parent.parent

LABELS = {
    "owner:M1": ("1f6fb2", "Divyanth: Application & Workload"),
    "owner:M2": ("6b47b8", "Devika: Automation & Platform"),
    "owner:M3": ("0f7a5a", "Bhavana: Observability"),
    "owner:All": ("5a6577", "Whole team"),
    "optional": ("cccccc", "Only after all mandatory items pass"),
}


def gh(*args, capture=False):
    if not APPLY and not capture:
        print("  [dry-run] gh", " ".join(args))
        return ""
    res = subprocess.run(["gh", *args], check=True, text=True,
                         stdout=subprocess.PIPE if capture else None)
    return res.stdout if capture else ""


def main():
    rows = list(csv.DictReader(open(ROOT / "docs" / "tasks.csv", newline="")))
    weeks = sorted({r["week"] for r in rows})
    phases = sorted({r["phase"] for r in rows}, key=lambda p: int(p.split()[0][1:]))

    labels = dict(LABELS)
    for w in weeks:
        labels[f"week-{w}"] = ("fbe9dd", f"Planned for week {w}")
    for p in phases:
        labels[p.split()[0]] = ("eef1f5", p)

    print(f"{len(labels)} labels")
    for name, (color, desc) in labels.items():
        gh("label", "create", name, "--color", color, "--description", desc, "--force")

    existing = set()
    if APPLY:
        out = gh("issue", "list", "--state", "all", "--limit", "500", "--json", "title", capture=True)
        existing = {i["title"].split(":")[0] for i in json.loads(out)}

    print(f"{len(rows)} tasks")
    for r in rows:
        if r["id"] in existing:
            print(f"  skip {r['id']} (exists)")
            continue
        title = f"{r['id']}: {r['title']}"
        body = (
            f"**Phase:** {r['phase']}  \n"
            f"**Owner:** {r['name']} ({r['owner_detail']})  \n"
            f"**Depends on:** {r['depends_on']}  \n"
            f"**Effort (est.):** {r['effort']}  \n"
            f"**Planned week:** {r['week']}\n\n"
            f"Steps, files, verification and evidence: see **{r['id']}** in "
            f"[`docs/reference/detailed-plan.md`](../blob/main/docs/reference/detailed-plan.md).\n\n"
            f"### Done when\n"
            f"- [ ] Steps completed as described in the plan\n"
            f"- [ ] Verification passed\n"
            f"- [ ] Evidence saved in `docs/screenshots/{r['id']}-*.png`\n"
            f"- [ ] PR reviewed by a member who does not own this task\n"
        )
        lbls = [f"owner:{r['owner']}", f"week-{r['week']}", r["phase"].split()[0]]
        if r["optional"] == "yes":
            lbls.append("optional")
        gh("issue", "create", "--title", title, "--body", body, "--label", ",".join(lbls))

    if not APPLY:
        print("\nDry run only. Re-run with --apply to create them.")


if __name__ == "__main__":
    main()
