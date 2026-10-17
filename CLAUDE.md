# CLAUDE.md — DK-AI

**DK-AI maps the organisational and social structure of public and non-profit AI
activity in Denmark**: who convenes whom, who governs it, who funds it, and when.

It is **not** a product catalogue, not a research-output database, and not a company
directory. If you feel the urge to describe what an AI *does*, you have left scope.

Two foci: **UCPH** and **AI in health**. They overlap heavily, so they are **views,
not folders** — every concept has exactly one home in its class folder.

This file is the **conventions layer**. `_okf/SPEC.md` is the vendored, pinned OKF v0.1
spec — the *contract*. Never edit it. Everything here is content-model territory the
spec deliberately leaves to the producer.

---

## 1. Scope — five tests

### Test 1 — the Structure Test (the solutions exclusion)

**In scope if it can hold a meeting.** A thing with members, governance or a mandate is
in. A thing with users, versions or an API is out.

- A hospital's sepsis-prediction model — **out**.
- The multi-partner consortium that built it — **in**, if it has ≥2 partner organisations
  *and* its own public identity (a page, a name, a named lead).
- A single-PI research project — **out**. That is research output, not social structure.
- Shared public infrastructure (Gefion, a national health-data platform) — **in** as
  `Infrastructure`, described purely as an anchor: who owns it, who allocates access,
  which initiatives depend on it. **No feature lists, no specs, no benchmarks.**

Deployed solutions are not a gap in this vault — they live at
[Nordic AI Health Map](/references/nordic-ai-health-map.md). Point there.

**The education carve-out.** A degree programme cannot hold a meeting, so it fails this
test. It is admitted as a deliberate, narrow exception, on this reasoning: **education
*organising* is structure; education *provision* is a catalogue someone else already
keeps.** Denmark's degree programmes are registered canonically by the state in
[UddannelsesGuiden](/references/uddannelsesguiden.md), which is current and complete. A
vault copy of it would be stale within a year and worse than the source.

So a programme earns a `Programme` concept **only when it connects two or more concepts** —
the same connectivity rule that governs people (§6):

1. it is offered **jointly by two or more institutions or faculties**, or
2. it was created or is run by a **mapped `Initiative`**, not simply by a department.

Every other AI programme is a **row** in the offering body's `# Activities` section, and the
national list lives at UddannelsesGuiden. **If you find yourself recording ECTS, exam forms
or learning objectives, you are building a course catalogue, and you have left scope.**

This is the third application of one rule the vault already follows: *record the structure
around a thing, and point at the registry of the things themselves.* Solutions point at the
Nordic AI Health Map; network members point at the network's own list; programmes point at
UddannelsesGuiden.

### Test 2 — the Public/Non-profit Test

**If its purpose is to sell, it is out. If its purpose is to convene, fund, govern,
research or coordinate, it is in.**

**In:** state, region, municipality, university, hospital, foundation, registered
association, non-profit cluster; and public–private consortia **where the coordinating
or lead entity is public or non-profit**.
**Out:** companies, company alliances, trade associations advancing members' commercial
interests, vendor user-groups, consultancies.

- Danish Life Science Cluster (corporate members, non-profit with a public mandate) — **in**.
  Its corporate members get no concepts.
- A Novo Nordisk Foundation programme — **in**. NNF is an erhvervsdrivende fond whose
  grant-making is non-profit. **Follow the money's purpose, not the donor's origin** —
  Novo Nordisk A/S is out.
- **Commercial partners are named in prose, never given a concept file.** This is the
  containment rule that stops DK-AI drifting into a company directory.

### Test 3 — the Denmark Test

In: a Danish seat, or Danish public/foundation funding. Nordic and EU bodies appear only
where they directly fund, govern, or admit as a member an in-scope Danish body — and never
as a research subject.

**How to type one:** the master test still applies. A foreign body that would exist without
AI is a thin `Organisation`; one that exists *because* of AI — ELLIS, for instance — is a
thin `Initiative`. Either way it carries a `> **Foreign-body stub.**` blockquote saying why
it was admitted, and it is never parsed in depth. A dataset or map we merely point at stays
a `Reference`.

### Test 4 — the Person Test

A `Person` concept requires a **named, publicly published role** in an in-scope body.
No researchers-known-only-by-publication, no network members, no attendees. See §6.

### Test 5 — the No-News rule

Press releases, news items and LinkedIn posts are **citations, never concepts**, and
never a `resource:`. `resource:` must be the body's own durable page. A body whose only
evidence is a news article is a **lead in `log.md`**, not a file.

---

## Tone — observational, never evaluative

This vault is shared with the people and bodies it describes. **It describes; it never
judges.** Every sentence about a body, a person or the landscape should read as an
observation that the body itself would recognise as fair.

- **Describe what is there, not what is absent.** Say where activity *is* organised
  ("AI-in-health work at UCPH is organised through DIKU, the Pioneer Centre and the
  hospitals"), not where it is not ("SUND has no AI centre").
- **An absence is a fact about this vault, not about the body.** Write *"not yet recorded
  in this vault"* or *"the site does not list it as of <date>"* — never *"not published"*,
  *"unconfirmed"*, *"missing"* or *"lacks"* as a characterisation of the body.
- **Report differing sources side by side, without comment.** *"The introduction describes
  … ; the listing names …"* — never *"contradicts"*, *"discrepancy"* or *"inconsistent"*.
- **Where a gap would once have been named, offer *possible further evolution*** — framed
  as options the landscape might take, in the conditional, never as a shortcoming or a
  recommendation. *"Possible further evolution: an elected board or published statutes."*
- **Scope decisions are about this vault's rules, not the body's merit.** A centre outside
  scope is *"not included under the current AI-focus rule"*, never *"excluded"* or *"fails"*.
- **No ranking words about bodies or people**: *only*, *most/least formal*, *lightly
  governed*, *rarely*, *merely*, *whatsoever*. Quantities are fine — *"one of 34 centres"*
  — but not as a verdict.
- **The vault's own errors are still logged plainly** in `log.md` as `**Correction**`.
  Candour about *our* mistakes is not a verdict on anyone else.

Research method is unchanged. Everything §9 requires — sources, dates, negatives, leads —
is still recorded, but in the vocabulary above. `/views/coverage/index.md` is the one place
where the vault's *own* search status is listed, and it keeps the same neutral framing:
*"searched on <date>; not yet recorded"*.

---

## 2. Format (inherited from OKF v0.1 and cpdse-okf-vault)

- One `.md` file = one concept. **The file path is the identity** — there is no `id:` field.
- Frontmatter, **closed set**: `type, title, description, resource, tags, timestamp`.
  `type` is the only required key. `okf_version: "0.1"` appears **only** in the root
  `index.md`. **No new keys are ever added** — see §5 on time.
- **No wikilinks.** Relationships are plain markdown links in the body.
- Links are **bundle-absolute**: `/initiatives/caisa.md`, not `../initiatives/caisa.md`.
- Reserved files: `index.md` (no frontmatter, bullet-list hub) and `log.md`
  (`## YYYY-MM-DD` headings, newest first, entries lead with a bold verb).
- Body headings are **H1 (`#`)**, in order: `# Summary` / `# Facts` → domain sections →
  `# Notes` → `# Links` → `# Citations`.
- `resource:` = the single canonical source URL. `timestamp:` = the **capture date**,
  not the edit date.
- Uncertainty is **inline prose** (`*Not independently confirmed in this pass.*`), never
  a frontmatter field.
- Filenames lowercase kebab-case, Danish diacritics transliterated: `ø→oe`, `æ→ae`, `å→aa`.
- **Length budget:** a concept body over ~120 lines is a smell. Facts table + three
  paragraphs + links + citations. **Distil, don't mirror.**

### Concept template

```markdown
---
type: Initiative
title: <name as the body writes it>
description: <one line, no volatile numbers>
resource: https://...
tags: [initiative, health, network, national]
timestamp: 2026-09-21T00:00:00Z
---

# Summary

# Facts

| | |
|---|---|
| Form | ... |
| Status | Active |

# Links

# Citations

[1] [label](url)
```

---

## 3. The ten types

**The master cut: *would this body exist if AI had never been invented?*
Yes → `Organisation`. No → `Initiative`. Unsure → `Initiative`.**

And the asymmetry that dissolves most boundary anxiety: **`Organisation` is a supporting
cast list, not a collection target.** Organisations exist so Initiatives have something
to link to. Never write one speculatively — write it when a second concept needs to link
to it, or when it holds a fact we need. It stays a small, near-closed set (~40 files).
`Initiative` is the open, growing set: it is *the thing we are collecting*.

| `type` | Folder | Definition |
|---|---|---|
| `Organisation` | `organisations/` | A durable body whose existence does not depend on AI. Universities, faculties, departments, hospitals, regions, municipalities, ministries, agencies, foundations, associations, non-profit clusters — **all one type**, distinguished by `\| Kind \|`. |
| `Initiative` | `initiatives/` | A named undertaking whose reason for existing is AI. Centres, strategic initiatives, consortia, networks, clubs, working groups — **all one type**, distinguished by `\| Form \|`. |
| `Governance Body` | `bodies/` | A standing organ that *governs or oversees* another concept. **Rare by design** — see the gate in §4. |
| `Person` | `people/` | A natural person in a named, publicly published role in an in-scope body. |
| `Event` | `events/` | A dated convening, or a recurring series of them (`\| Form \| series` vs `instance`). |
| `Funding Programme` | `funding/` | A named pot of money with rules, a call, or an allocation decision. |
| `Policy` | `policy/` | A normative instrument: national strategy, statute, rules of procedure. |
| `Infrastructure` | `infrastructure/` | Shared public/non-profit infrastructure that initiatives organise around. An **anchor, never a product**. |
| `Programme` | `programmes/` | A named, publicly offered course of study whose subject is AI or its direct application **and which connects two or more concepts** — jointly offered, or run by a mapped initiative. **The one exception to the Structure Test**, and rare by design; see §1. |
| `Reference` | `references/` | An external dataset or map DK-AI points at rather than replicates. |
| `Log` | `snapshots/` | A dated snapshot of state with **no single durable subject**. Kept near-empty. |

**Folder↔type invariant:** every file in `people/` is `type: Person`, every file in
`initiatives/` is `type: Initiative`, and so on. This is a checkable CI rule.

### Types deliberately rejected

Do not reintroduce these. A new type requires a `log.md` entry justifying it against
this table.

| Rejected | Why | Promotion trigger |
|---|---|---|
| `Centre`, `Network`, `Consortium`, `Cluster`, `Working Group` | Unstable, often plural self-labels → `Initiative` + `\| Form \|` | Never |
| `Institution` / `Organisation Unit` split | Earns nothing without an institution-partitioned tree; `\| Kind \|` recovers it | Never |
| `Faculty`, `Department`, `Hospital`, `Region`, `Ministry`, `Foundation` | Five types for one `Part of` chain | Never |
| `Role` | Here nearly every role is one-per-body ("Chair of X"); a file per chairship is pure proliferation | A role defined by a document independent of any single body, referenced by ≥2 bodies |
| `Role Holding` / `Appointment` | The `\| Seat \| Holder \| Term \|` row **is** the reification, and costs one line | Never |
| `Grant` / `Award` | A row in two places, not an entity | Never |
| `Project` | Research output, not social structure | If it has ≥2 partner orgs *and* its own public identity → it is an `Initiative` |
| `Solution` / `System` / `Tool` / `Model` | This is the vault's whole point | Never |
| `Publication` / `Report` | `# Citations`, or `Reference` if it is a dataset | Never |
| `Topic` / `Theme` / `Domain` | Tags. Files about abstractions attract essays | Never |

---

## 4. Boundary rules

- **A centre that is also a consortium is ONE file.** `| Form | national centre / consortium |`
  plus `Led by:` and `Partners:` rows. The consortium-ness is a relation set, not a second
  entity. Split only if the consortium has both a *different membership* and its own
  published name.
- **A cluster is an `Organisation`; its AI network is an `Initiative`.** (Danish Life
  Science Cluster vs its AI netværk; KL vs KL's Netværk for kunstig intelligens.)
- **Governance Body gate — do not create one by default.** It earns a file only when it
  has **≥5 named members**, **or** published rules of procedure or a mandate, **or** a
  membership spanning organisations we want linked as a graph. Otherwise it is a
  `# Governance` table inside its parent Initiative. Promotion is cheap: move the table
  out, replace it with a `Governed by` row.
- **Sub-units are `Initiative`s, but only once they earn it.** Working groups and
  collaboratories start as a `# Structure` table on the parent; a row is promoted to its
  own file the moment it has a published lead, mandate or output.
- **Event gate (three-part):** a file requires (a) a date, (b) an in-scope named convening
  body, (c) a published programme or named speakers. Fails any → a row in the convener's
  `# Activities` table. This stops `events/` becoming a calendar scrape. A **series**
  concept is created only when a *second* instance is confirmed.
- **A `Programme` is a course of study — not a body, and not a course — and it must
  connect.** A file requires *both* that AI or machine learning is the programme's
  **stated subject**, *and* that it connects ≥2 concepts (§1). Adjacent fields do not
  qualify by proximity: a health-informatics or digital-health degree that does not name
  AI as its subject is **not** an AI programme, however data-heavy it is.
  - **File:** a joint degree across faculties or institutions; a PhD or postdoc programme run
    by a mapped network.
  - **Row** in the provider's `# Activities`: a single-provider AI degree, however
    prominent; a named AI specialisation; a continuing-education AI programme.
  - **Nothing:** individual courses and modules; degrees that merely contain AI teaching.
  - **`Organisation`, not `Programme`:** PhD schools and study boards.
  - A **proposed** programme stays a row on the body proposing it until it has a name and a
    provider — the same logic as the Event gate.

  Record `Level`, `Offered by`, `Status` and the web page — nothing that resembles a syllabus.
- **Companies are never concepts.**
- **A re-classification is never a reason to move a file.** Path is identity.

---

## 5. Time

**The rule that matters most: a file never changes its path because time passed.** A
future event does not move when it happens. A dissolved organisation is not deleted or
merged. A rebranded centre keeps its filename.

Three layers of time, kept apart:

1. **`timestamp:` = when *we* captured this file.** Never the event date, never an edit
   date. It is the default as-of for every volatile fact in the file.
2. **`# Facts` rows = the world's time.** `Status`, `Period`, `Date`, `Founded`, `As of`.
3. **`log.md` = the vault's time.** What we learned, when, and what we got wrong.

**No new frontmatter fields.** Chronological sorting of events comes free from a
**date-prefixed filename** (`events/2026-10-27-…`), which beats a `date:` key because it
is also permanent identity.

| Case | Convention |
|---|---|
| **Past one-off event** | `\| Form \| instance`, `\| Date \| 2025-09-29 – 2025-09-30`, `\| Status \| Held`. Date-prefixed filename, past tense, `# Outcome` if anything was published. |
| **Future event** | `\| Status \| Announced` plus a blockquote under `# Summary`: `> **Forward-looking — announced, not yet held.** Captured <date>.` When it happens: **same file, same path** — flip `Status`, delete the blockquote, add `# Outcome`, bump `timestamp`, log an `**Update**`. |
| **Term-limited appointment** | 3-col `\| Seat \| Holder \| Term \|` table on the **appointing body only**. Where terms exist but dates are not published: `2-year term, start not published` — **never guess**. On turnover the outgoing holder moves to `# Notes`, never deleted: the roster is the historical record. |
| **Dissolution + succession** | Predecessor: `\| Status \| Dissolving 2026-12-31 \|` + `\| Succeeded by \| [link] \|`. Successor: `\| Succeeds \| [links] \|`. The **succession narrative has exactly one home — the successor's `# Succession` section**; three predecessors × one story would be three drifting copies. If the successor's name is not yet published, use a descriptive slug and say so; the eventual rename is a genuine identity change, logged as `**Rename**` with the old path kept in `\| Also known as \|`. |
| **Volatile counts** | `\| Members \| 173 *(as of 2026-09-21)* \|`. **Never in `description:`** — descriptions get cached into `index.md` entries and go stale invisibly. Whole-concept volatility gets a `> **Dated snapshot — volatile.**` blockquote. |

`type: Log` is reserved for genuinely **subjectless** landscape snapshots. Entities are
durable and **updated in place**, never snapshotted into new files.

---

## 6. People

A public repo of named Danish researchers needs a privacy policy. This one is binding.

- A `Person` concept exists **only** when the person is named on an **official published
  page in a named professional role** relevant to an in-scope concept. `resource:` is
  that page, always. If you cannot fill a `| Role |` row linking to an in-scope concept,
  **do not create the file** — name them in prose on the body instead.
- **A person becomes a file when they connect two or more concepts.** Holding a named
  role in a single mapped body is *not* enough: that person is already fully described by
  the roster row they appear in, and a file would only restate it. Create the file when
  either:
  1. they hold named roles in **≥2** mapped concepts (a committee seat *and* a centre
     directorship), or
  2. they are the **chair, director or lead** of a mapped concept — the one seat whose
     occupant the rest of the graph needs to reach.

  This is "distil, don't mirror" applied to people, and it is also the strongest privacy
  posture available: the vault holds files only for those whose role *structure* is the
  point, never for everyone whose name appears on a page. A roster row naming someone and
  their unit is the published fact; a person file is a claim that they are a node in the
  network.
- Record: name, published professional title, institutional affiliation, the roles they
  hold in vault concepts, links. **Nothing else.**
- **No personal contact details.** A functional mailbox (`ai@ku.dk`) belongs on the body,
  never on a person.
- No biographical, personal, political or health information. No inferred seniority,
  influence rankings, or network-centrality claims about individuals.
- **No aggregation beyond a single official page** — do not assemble a profile by
  combining sources into something not published anywhere.
- Event speakers without a named role in a mapped body stay as **plain text** in
  `# Programme`. An event programme hands you thirty names; this is where person-file
  explosion would start.
- Removal on request: see the note in `/people/index.md`.

### Where a role-holding lives canonically

**The roster owns the seat; the person owns the CV-line.**

| Fact | Canonical home | Other side carries |
|---|---|---|
| Employment / academic affiliation | **Person** — `\| Unit \| [link] \|` | the department carries nothing; we never enumerate employees |
| Appointment to a named seat | **The body** — `# Membership`, 3-col table | Person carries an **undated** `\| Role \| Chair, [body](…) \|` link |
| Leadership of an initiative | **The Initiative** — `# Governance` table | Person carries an undated link |
| Functional contact | **The Initiative** | Person: nothing |

Why: (1) capture the fact **where the source publishes it** — ai.ku.dk publishes the
roster, the maths department does not publish "our staff on AI bodies"; (2) capture it
on the **bounded** side — a roster is twelve and published as a unit, a department's
staff list is unbounded; one file edit per turnover instead of twelve; (3) **links may
be bidirectional; facts must not be.** The edge appears on both sides for navigability;
the term, seat and dates appear once.

---

## 7. The relation vocabulary (closed)

OKF has no typed edges. The left column of a headerless two-column `# Facts` table is the
only edge-labelling mechanism available, so **treat it as a closed vocabulary**. Anything
not on this list goes in **prose**, not a new row label. Row-label proliferation is the
same disease as type proliferation.

| Label | Value |
|---|---|
| `Kind` | **Organisation only.** Sub-class: university / faculty / department / hospital / region / municipality / state agency / ministry / foundation / association / cluster |
| `Form` | Initiative or Event self-label: centre / network / consortium / strategic initiative / working group / series / instance |
| `Status` | `Planned` · `Announced` · `Active` · `Dormant` · `Dissolving <date>` · `Dissolved <date>` · `Superseded <date>` · `Held` · `Cancelled` · `Unknown` |
| `Period` · `Date` · `Founded` · `As of` | dates and spans |
| `Part of` · `Hosted by` · `Led by` · `Partners` | containment and membership links |
| `Governed by` · `Governs` | to and from a Governance Body |
| `Title` | a person's published professional title |
| `Chair` · `Deputy chair` · `Director` · `Head` · `Deputy head` · `Co-lead` · `Secretariat` | seat rows (person links) |
| `Member` | membership of a governance body |
| `Members` | count and/or composition + `*(as of …)*` |
| `Funded by` · `Awards` · `Volume` · `Instrument` | funding |
| `Succeeds` · `Succeeded by` | organisational succession |
| `Convened by` · `Part of series` · `Venue` | Event |
| `Level` · `Offered by` | Programme only: bachelor / master / continuing education, and the body that runs it |
| `Also known as` · `Web` | aliases, canonical site |

---

## 8. Tags

Fixed order: **class → focus → form/kind → geo/sector → subject.** Max five tags, ASCII
kebab, lowercase, no `#`.

| Slot | Values |
|---|---|
| class | `organisation` `initiative` `body` `person` `event` `funding` `policy` `infrastructure` `programme` `reference` `snapshot` |
| **focus** | `ucph` · `health` — **load-bearing; these drive the two views.** Both may apply; neither is required |
| form/kind | `centre` `network` `consortium` `strategic-initiative` `working-group` `cluster` `steering-committee` `series` `university` `faculty` `department` `hospital` `region` `municipality` `state-agency` `ministry` `foundation` `association` |
| geo/sector | `national` `regional` `municipal` `nordic` `eu` · `au` `aau` `dtu` `itu` `sdu` `ruc` `cbs` |
| subject | `governance` `education` `data-infrastructure` `clinical` `nlp` `imaging` `succession` `funding` |

- **No status tags** (`active`, `dissolved`). A tag cannot carry an as-of date, so a
  stale status tag is a lie. Status is a `# Facts` row.
- **No person-name tags. No year tags.** Names are links; years are rows.
- **Tags never determine where a file lives.** Organisation is folder-per-class.
- A new subject tag needs a `log.md` line.

---

## 9. Collection method

**One pass = one source-cluster or one class-sweep, capped at ~10–15 new concepts,
ending in exactly one `log.md` entry and updated `index.md` files.** A pass that cannot
be described in one log heading is two passes. **A pass that does not touch an index is
not finished.**

### Four pass types

1. **Frame pass** (first, once). Write the `Organisation` stubs the seeds will link to.
   Stubs only: name, kind, parent, web, citation. Purpose: links resolve from day one and
   no later pass stalls on a missing target. **Exempt from the 15-concept cap** — a stub
   is a link target, not a researched concept, and the cap exists to bound research depth.
   Frame stubs carry a `> **Frame stub.**` note until something expands them.
2. **Entity pass.** One Initiative and its immediate neighbourhood — governance body,
   named people, funder links, flagship event. Deep and narrow.
3. **Sweep pass.** One *class* across the whole frame — "the AI page of every Danish
   university", "every region's AI programme", "every foundation's AI call".
   **This is the anti-seed-bias instrument.**
4. **Verification pass.** **Zero new concepts.** Re-fetch `resource:` for the oldest
   `timestamp:`s, refresh `Status` and `As of` rows, flip `Announced → Held`, log
   corrections. Run one after every three passes of type 2/3.

**Alternate pass types 2 and 3 — never two entity passes in a row.** Discipline, not
judgement. The seeds this vault started from are UCPH-heavy and health-heavy;
snowballing from them alone would produce a map of UCPH's own outbound links.
**Frame-first, not seed-first:** `/views/coverage/index.md` holds the frame this vault is
measured against. Check it before starting a pass.

### Discovery surfaces, ranked

1. Steering-committee and coordination-group **rosters** — highest yield; every member's
   home unit is a new lead and a new `Part of` chain.
2. Partner / member lists on in-scope pages.
3. **Event programmes** — usually the densest single page in the landscape.
4. **Funding databases** (NNF grants, Innovationsfonden, DFF, Nordforsk, CORDIS filtered
   to DK) — these surface consortia that have no website.
5. Ministry / agency agreement and press pages — for policy instruments and money.
6. The **Nordic AI Health Map's organisation column** — read for organisation leads while
   deliberately ignoring its solution rows.
7. University org charts and faculty centre listings.
8. **Job advertisements** — a posting for "coordinator, X AI centre" proves the centre
   exists and often names its governance.
9. Social media — **leads only**, never evidence (Test 5).

### Stopping criteria

- Stop a pass at the 15-concept cap; **or** when three consecutive snowball hops yield no
  new in-scope entity; **or** when you are about to write something that fails the
  Structure Test — stop and log why. That judgement is the valuable artefact.
- Declare a focus **mapped** when a sweep yields fewer than **1 new entity per 10 checks**.
  Record the ratio in the log so completeness is measurable rather than asserted.
- **Never stop mid-pass without a log entry.** An unlogged partial pass is worse than no
  pass: the next agent cannot tell what was searched.

### Binding rules for every pass

- Every fact traceable to a page **actually opened**: `resource:` + a `# Citations` entry.
  **Never write a fact a search engine summarised but you did not read on the source page.**
- **Read PDFs with `pdftotext -layout`** (poppler, installed via Homebrew). `WebFetch` cannot
  read compressed PDF streams: it reports them as "corrupted" or returns a partial answer
  that looks complete. Board papers, study regulations and agreements are often the **only**
  primary source for a body, so a PDF that will not open is not a dead end. Save it, then
  extract it locally.
- **Never invent a person's role.** Where a role is not listed, write it as the vault's
  knowledge state: *"The group's composition is not yet recorded in this vault; the site
  does not list it as of <date>."*
- **Naming:** filename = the body's own primary self-name, transliterated; `title:`
  carries both languages; every alias gets an `| Also known as |` row so `grep` finds the
  file and the next pass does not create a duplicate.

### Recording what is not yet recorded — two homes, deliberately

- **Per-pass** → `log.md`, under a `**Not yet recorded**` bullet.
- **Durable** → `/views/coverage/index.md`, under *Not yet recorded, by body*, with a date.

`log.md` is append-only history nobody greps before starting.
`/views/coverage/index.md` is the surface the next agent actually opens.

### `log.md` entry shape

One heading per pass, newest first, bullets in this order:
`**Research**` (what was read) · `**Creation**` (what was written, by type) ·
`**Update**` · `**Correction**` · `**Not yet recorded**` ·
`**Leads not yet written**` · `**Open points**` · `**Coverage**` (the ratio).

---

## 10. The linter

`ruby bin/lint.rb` (add `--warnings` to list warnings). Deterministic, no LLM — both
tiers are mechanical checks, not judgements. Run it before finishing any pass.

**Tier 1 — OKF conformance (§9 of `_okf/SPEC.md`). Genuine violations.** The real bar is
small: every non-reserved `.md` has parseable YAML frontmatter; every frontmatter has a
non-empty `type`; `index.md` and `log.md` follow §6/§7, and only the bundle-root
`index.md` carries frontmatter.

**Tier 2 — local policy. House rules.** The spec *explicitly tolerates* broken
cross-links, unknown `type` values and missing indexes; consumers must not reject a
bundle for them. **A bundle failing only Tier 2 is still conformant OKF — never report
Tier 2 findings as "non-conformant."** Tier 2 checks: frontmatter keys inside the closed
set; `title`/`description`/`resource` present; `timestamp` a real ISO 8601 datetime
(validated against the raw text, because YAML silently coerces date-like scalars);
folder↔type invariant; tags inside the §8 vocabulary and at most five; a `# Citations`
section; every link resolves; no concept files under `views/`.

**Warnings** (non-blocking): relation labels outside the §7 vocabulary, concepts not
linked from any `index.md`, **a concept carrying a focus tag that the matching focus view
does not list**, and a `timestamp` more than twelve months old — the last is the signal
that a verification pass is due.

The focus-view check is the one that keeps §4's central bet honest. The foci are expressed
as *tags plus views* rather than as folders, so a concept that is tagged `health` but
missing from `views/health/index.md` is invisible in the very page that is supposed to be
the whole answer to that focus. Nothing else would catch it: the concept still lives in its
class folder and is still listed there.

`CLAUDE.md` and `README.md` are repo prose, not bundle concepts, and are excluded: their
fenced examples contain illustrative links that must not be resolved.

## 11. Divergences from cpdse-okf-vault

The sibling vault at `../CPDSE/cpdse-okf-vault` uses the same format but a different
content model. An agent that reads it first will otherwise "correct" these back. They are
deliberate.

1. **Merged `Institution` / `Organisation Unit` / `Organisation`** into one `Organisation`
   + `| Kind |`. The sibling's split earns its keep because its tree is partitioned by
   institution (`ucph/` vs `sdu/`); this one is not.
2. **No `System` type.** The sibling has 13; here, solutions are the one thing this vault
   exists to exclude.
3. **Seats live on the body, not the person.** The sibling's `anders-bach.md` puts
   "Observer, Study Board" on the person. Here the board owns the seat.
4. **Bundle-absolute links** (`/initiatives/caisa.md`) — the spec's recommended form. The
   sibling uses relative links throughout.
5. **`Log` restricted to subjectless snapshots.** The sibling's `season-3.md` puts time
   into the type and the filename, producing `season-3.md`, then `season-4.md`, and no
   durable subject. Here entities are updated in place.
6. **A person policy exists.** The sibling has none.
7. **`Programme` is rare, thin, and has no `Course` beneath it.** The sibling holds 86
   `Course` concepts with ECTS, exam forms and læringsmål, because it is a descriptive parse
   of an institution's teaching. This vault records a programme only when it is evidence of
   organising — jointly offered, or run by a mapped initiative — and points at
   UddannelsesGuiden for everything else.
8. **No bundle tag.** The sibling leads every tag list with `cpdse` or `pharmaschool`
   because it holds two bundles. This vault holds one, so the tag would be noise on every
   file.
