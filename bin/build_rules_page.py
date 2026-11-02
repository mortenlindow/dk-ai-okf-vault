#!/usr/bin/env python3
"""Build site/clinical-ai-rules.html from the policy/ concepts of the clinical-AI rules register.

Usage: python3 bin/build_rules_page.py   (run from the repo root after changing policy/)
Levels come from the section headings of policy/index.md; everything else from each file.
"""
import re, json, os
root = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
LEVEL = {}
idx = open(f"{root}/policy/index.md").read()
cur = None
for line in idx.splitlines():
    if line.startswith("## National"): cur = "national"
    elif line.startswith("## Professional"): cur = "prof"
    elif line.startswith("## Regions"): cur = "regions"
    elif line.startswith("## Hospitals"): cur = "hosp"
    m = re.match(r"\* \[.*?\]\(([\w-]+)\.md\)", line)
    if m and cur: LEVEL[m.group(1)] = cur
MONTHS = {m: i+1 for i, m in enumerate("january february march april may june july august september october november december".split())}
def sortdate(s):
    s = s.lower()
    m = re.search(r"(\d{1,2}) (" + "|".join(MONTHS) + r") (\d{4})", s)
    if m: return f"{m.group(3)}-{MONTHS[m.group(2)]:02d}-{int(m.group(1)):02d}"
    m = re.search(r"(" + "|".join(MONTHS) + r") (\d{4})", s)
    if m: return f"{m.group(2)}-{MONTHS[m.group(1)]:02d}-01"
    m = re.search(r"\b(20\d\d)\b", s)
    if m: return f"{m.group(1)}-01-01"
    return None
def plain(md): return re.sub(r"\[([^\]]+)\]\([^)]+\)", r"\1", md).replace("*", "")
def force_cat(f):
    f = f.lower()
    if f.startswith("input"): return "input"
    if f == "not read": return "stub"
    if any(k in f for k in ("binding","instruction","must","delegation")): return "binding"
    if f.startswith("recommendation"): return "recommendation"
    return "guidance"
REGIONS = ["Region Nordjylland","Region Midtjylland","Region Syddanmark","Region Sjælland","Region Hovedstaden"]
out = []
for slug, lvl in LEVEL.items():
    s = open(f"{root}/policy/{slug}.md").read()
    fmv = lambda k: re.search(rf'^{k}: "?(.*?)"?$', s, re.M).group(1).replace('\\"','"')
    facts = dict(re.findall(r"^\| ([A-Z][\w ]+?) \| (.*?) \|$", s, re.M))
    tags = re.search(r"^tags: \[(.*?)\]", s, re.M).group(1).split(", ")
    prov = re.findall(r"^- (.+)$", s.split("# Key provisions")[1].split("\n# ")[0], re.M) if "# Key provisions" in s else []
    summary = " ".join(s.split("# Summary")[1].split("# Facts")[0].split("\n\n")[-2 if "Login-walled" in s else -1].split()) if True else ""
    summary = re.sub(r"\s*\[\d+\]", "", plain(summary)).strip()
    issuer = plain(facts.get("Issued by",""))
    region = next((r for r in REGIONS if r in issuer), None)
    if slug.startswith("cai-x"): region = "Region Syddanmark"
    focus = next((t for t in tags if t in ("generative-ai","imaging","clinical","governance")), "clinical")
    out.append(dict(id=slug, level=lvl, title=fmv("title"), desc=fmv("description"), url=fmv("resource"), path=f"policy/{slug}.md",
        issuer=issuer, form=plain(facts.get("Form","")), force=plain(facts.get("Force","")), cat=force_cat(facts.get("Force","")),
        date=plain(facts.get("Date","")), updated=plain(facts.get("Updated","")), sort=sortdate(facts.get("Date","")) or sortdate(facts.get("Updated","")),
        audience=plain(facts.get("Audience","")), specialty=plain(facts.get("Specialty","")), access=plain(facts.get("Access","")),
        status=facts.get("Status",""), region=region, focus=focus, provisions=[plain(p) for p in prov]))
data = json.dumps(out, ensure_ascii=False).replace("</", "<\\/")
tpl = open(f"{root}/bin/templates/clinical-ai-rules.html").read()
assert tpl.count("__DATA__") == 1
open(f"{root}/site/clinical-ai-rules.html", "w").write(tpl.replace("__DATA__", data))
print(f"site/clinical-ai-rules.html: {len(out)} documents")
