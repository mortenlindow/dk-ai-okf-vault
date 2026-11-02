#!/usr/bin/env python3
"""List what is due for re-checking in the vault, and which source cluster this run sweeps.

Used by the biweekly update (bin/biweekly-update.md). Mechanical, no web access: it reads the
`# Facts` rows and `timestamp:` of every concept and reports
  1. Announced/Planned items whose dates have all passed (status flip candidates),
  2. dissolutions, mergers and stated revision or run dates that have passed,
  3. the oldest captures, for re-reading,
plus the sweep cluster for the given date. Usage: python3 bin/due.py [YYYY-MM-DD]
"""
import datetime as dt
import glob
import os
import re
import sys

root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
today = dt.date.fromisoformat(sys.argv[1]) if len(sys.argv) > 1 else dt.date.today()
CONCEPT_DIRS = ["organisations", "initiatives", "bodies", "people", "events", "funding",
                "policy", "infrastructure", "programmes", "training", "references"]
OLD_AFTER_DAYS = 90   # a capture older than this is re-read
OLD_CAP = 12          # at most this many old captures per run

# Rotating sweep: one cluster per run, in this order, from the first run on 2026-11-16.
CLUSTERS = [
    ("Health networks and national bodies",
     "aisundhed.dk, Danish Life Science Cluster, Digital Sundhed Danmark, KL, Danske Regioner, the regions' AI programmes"),
    ("Training for clinicians",
     "Lægedage/PLO/DSAM catalogues, regional course catalogues, DSR/FSUS, Danske Fysioterapeuter, Pharmakon, other professional associations, commercial suppliers"),
    ("Clinical rules: national authorities and legislation",
     "Styrelsen for Patientsikkerhed, Sundhedsstyrelsen, Lægemiddelstyrelsen, Datatilsynet, Digitaliseringsstyrelsen, Dataetisk Råd, retsinformation.dk and høringsportalen.dk"),
    ("Clinical rules: regions and hospitals",
     "the regions' public instruction databases (e-Dok, PRI, VIP and others), hospital and department pages"),
    ("Research rules",
     "Uddannelses- og Forskningsministeriet's code, the research-ethics committees, DFF, Novo Nordisk Fonden, Villum, Lundbeck, Carlsberg and other funders"),
    ("Education rules",
     "the eight universities' rules on generative AI, Styrelsen for Undervisning og Kvalitet, Børne- og Undervisningsministeriet, STIL, school-level organisations"),
    ("UCPH",
     "ai.ku.dk, the AI Office, UCPH centres and faculties; the KU leads in /views/research-education-ai-rules/index.md"),
    ("Professional and patient organisations' input",
     "Lægeforeningen, Danske Patienter, DSAM, FYAM, PLO, Dansk Sygeplejeråd and others: positions, consultation responses, proposals"),
]
FIRST_RUN = dt.date(2026, 11, 16)

MONTHS = {m: i for i, m in enumerate(
    ["january", "february", "march", "april", "may", "june", "july", "august",
     "september", "october", "november", "december"], 1)}
DATE_RE = re.compile(r"(\d{4})-(\d{2})-(\d{2})|(\d{1,2})[.]? (" + "|".join(MONTHS) + r") (\d{4})", re.I)


def dates_in(text):
    out = []
    for m in DATE_RE.finditer(text):
        try:
            if m.group(1):
                out.append(dt.date(int(m.group(1)), int(m.group(2)), int(m.group(3))))
            else:
                out.append(dt.date(int(m.group(6)), MONTHS[m.group(5).lower()], int(m.group(4))))
        except ValueError:
            pass
    return out


def read(path):
    text = open(path, encoding="utf-8").read()
    ts = re.search(r"^timestamp:\s*(\d{4}-\d{2}-\d{2})", text, re.M)
    facts = {}
    for label, value in re.findall(r"^\| ([^|]+?) \| (.+?) \|\s*$", text, re.M):
        facts.setdefault(label.strip(), value.strip())
    return (dt.date.fromisoformat(ts.group(1)) if ts else None), facts


flips, passed, old = [], [], []
for d in CONCEPT_DIRS:
    for path in sorted(glob.glob(f"{root}/{d}/**/*.md", recursive=True)):
        if path.endswith("/index.md"):
            continue
        rel = os.path.relpath(path, root)
        ts, f = read(path)
        status = f.get("Status", "")
        dated = " ".join(f.get(k, "") for k in ("Date", "Updated", "Period", "Status"))
        ds = dates_in(dated)
        if re.match(r"(Announced|Planned)", status):
            if ds and max(ds) < today:
                flips.append((rel, status, max(ds)))
        for k in ("Status", "Updated"):
            v = f.get(k, "")
            if re.search(r"next revision|next run|runs |closes|Dissolving|merges|Operating", v, re.I):
                due = [x for x in dates_in(v) if x < today]
                if due and (rel, status, max(due)) not in flips:
                    passed.append((rel, f"{k}: {v}", max(due)))
        if ts and (today - ts).days > OLD_AFTER_DAYS:
            old.append((ts, rel))

print(f"# Due on {today.isoformat()}\n")
print("## 1. Status flip candidates (Announced/Planned, all dates passed)\n")
for rel, s, d in flips or [("none", "", None)]:
    print(f"- {rel}" + (f" — {s} (latest date {d})" if d else ""))
print("\n## 2. Stated dates that have passed (revision, runs, dissolution, merger)\n")
for rel, v, d in passed or [("none", "", None)]:
    print(f"- {rel}" + (f" — {v}" if d else ""))
print(f"\n## 3. Oldest captures (older than {OLD_AFTER_DAYS} days, at most {OLD_CAP})\n")
for ts, rel in (sorted(old)[:OLD_CAP] or [(None, "none")]):
    print(f"- {rel}" + (f" — captured {ts}" if ts else ""))
n = max(0, (today - FIRST_RUN).days // 14) % len(CLUSTERS)
name, surfaces = CLUSTERS[n]
print(f"\n## 4. Sweep cluster for this run ({n + 1} of {len(CLUSTERS)})\n")
print(f"**{name}** — {surfaces}")
print("\n## 5. Lead lists\n")
for path in sorted(glob.glob(f"{root}/views/**/index.md", recursive=True)):
    if "Leads not yet written" in open(path, encoding="utf-8").read():
        print(f"- {os.path.relpath(path, root)}")
