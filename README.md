# DK-AI

An [Open Knowledge Format](_okf/SPEC.md) vault mapping **public and non-profit AI
initiatives, networks, clubs and governance in Denmark**.

It answers structural questions — *who convenes whom, who governs it, who funds it, and
when* — with two initial foci: **the University of Copenhagen**, and **AI in health**.

## What is in it

Organisations, AI initiatives, governance bodies, named role-holders, events, funding
programmes, policy instruments and shared public infrastructure. Each is one markdown
file with a small YAML header, linked to the others by ordinary markdown links.

## What is deliberately not in it

Concrete AI solutions, apps, models and software products. This is a map of
organisational structure, not a product catalogue. Deployed Nordic healthcare AI is
already mapped by the [Nordic AI Health Map](https://healthmap.newnordics.ai/), which
this vault links to rather than duplicates.

Commercial entities are named in prose where they participate in a public or non-profit
body, but never get concept files of their own.

## People

Person entries are restricted to individuals named on an official published page in a
named professional role, and record only that published role information. No contact
details, no biographical material, no aggregation across sources. See §6 of
[CLAUDE.md](CLAUDE.md), and [people/index.md](people/index.md) for removal requests.

## Reading it

Start at [index.md](index.md). Every directory has an `index.md` describing what it
holds. [views/](views/) contains curated cross-cutting lenses — the UCPH view, the health
view, and a coverage checklist recording what has been searched and what has not.

## Published pages

`site/` holds the source of pages built from the vault. It is published on GitHub Pages at
https://mortenlindow.github.io/dk-ai-okf-vault/ by `.github/workflows/pages.yml` on every push
to `main` that touches `site/`. The workflow adds a doctype, charset and viewport to any page
that is an HTML fragment, so the sources can also be published as Claude artifacts unchanged.

- `site/ai-at-ucph.html` — **AI at UCPH**, a visual summary of the UCPH view, at
  https://mortenlindow.github.io/dk-ai-okf-vault/ai-at-ucph.html and as a private artifact at
  https://claude.ai/artifact/1DDCVrmJZ72ZoNYaMJdUG5. To update it, edit this file and
  republish it to that URL, so the link stays the same. The page carries its facts inline,
  so when the vault changes, the page has to be updated to match.

## Checking it

```
ruby bin/lint.rb --warnings
```

Two tiers, kept apart: **Tier 1** is OKF conformance (a genuine violation); **Tier 2** is
this vault's own policy — link integrity, the closed frontmatter key set, the folder/type
invariant, the tag vocabulary. A bundle that fails only Tier 2 is still conformant OKF.
Warnings flag concepts missing from an index and entries whose capture date has passed
twelve months.

## Contributing

[CLAUDE.md](CLAUDE.md) is the contract: scope tests, the type system, the relation
vocabulary, the tag list, and the research-pass method. Read it before adding anything.
Every fact needs a `resource:` URL and a `# Citations` entry pointing at a page that was
actually opened.
