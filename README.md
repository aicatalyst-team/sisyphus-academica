<div align="center">

# Sisyphus Academica

**Open-source research pipeline — literature review, novelty generation, citation verification, and adversarial review.**

[![CI](https://github.com/argahv/sisyphus-academica/actions/workflows/ci.yml/badge.svg)](https://github.com/argahv/sisyphus-academica/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Python 3.10+](https://img.shields.io/badge/python-3.10+-blue.svg)](pyproject.toml)
[![GitHub Stars](https://img.shields.io/github/stars/argahv/sisyphus-academica?style=social)](https://github.com/argahv/sisyphus-academica)

</div>

A self-coordinating pipeline of 20+ specialized agents that helps researchers find papers, generate novel hypotheses, verify citations, and improve writing quality. Not a paper mill — a research assistant that handles the grunt work so you can focus on the thinking.

```bash
pip install sisyphus-academica
sisyphus demo     # See the pipeline in action (no API keys needed)
sisyphus write "transformer efficiency"   # Full pipeline
```

---

## What It Does

| Task | Without Sisyphus | With Sisyphus |
|------|------------------|---------------|
| Literature review | Read 10-50 papers manually | Scouts 500+ across 4 APIs in parallel |
| Citation checking | Trust the author | Verified against Semantic Scholar + CrossRef |
| Novel ideas | "What's the gap?" | 6 engines generate 50+ structured hypotheses |
| Writing quality | Post-hoc AI detection | 41 Humanizer patterns enforced during generation |
| Peer review | Wait months for reviewers | 10 adversarial personas review in parallel |

**SIREN paper output** ([view full example](examples/siren-paper/)): 13-page PDF, 26 verified citations, 3 figures, 0 hallucinated references, 0 AI-pattern violations.

---

## Quick Start

### One command (recommended)

```bash
pip install sisyphus-academica
```

Then configure your literature API keys (free, optional — works without them at lower rate limits):

```bash
sisyphus configure
```

### Without installing

Browse the novelty engines and reviewer personas as standalone skills:

```
# These work with any agent (Claude Code, Codex, Cursor, etc.)
git clone https://github.com/argahv/sisyphus-academica
cp -r skills/novelty-engines ~/.claude/skills/
cp -r skills/reviewers ~/.claude/skills/
```

---

## What You Get

### 6 Novelty Engines (The Moat)

| Engine | What it does | Best for |
|--------|-------------|----------|
| **Contrarian** | Inverts every well-established claim — generates 10 counter-hypotheses | Breaking out of consensus thinking |
| **Cross-Pollinator** | Imports solutions from 15 distant fields (astrodynamics → biology, monetary policy → ML) | Stuck problems |
| **Assumption Excavator** | Finds unstated assumptions and tests what breaks if they're false | Design reviews |
| **Counterfactual Generator** | Rewrites a field's history without the most-cited papers | Finding overlooked approaches |
| **Paradox Sifter** | Cross-references "Limitations" sections across papers to find contradictions | Literature review gaps |
| **Heretic** | Generates 50 wild hypotheses from title+abstract alone, scores against reality | Breakthrough ideas |

### 10 Adversarial Reviewers

| Persona | Focus | Typical Critique |
|---------|-------|-----------------|
| Theorist | Formal proofs | "Where's the formal proof?" |
| Empiricist | Experimental design | "Your baseline is wrong" |
| Pragmatist | Practical applicability | "Does this matter in practice?" |
| Skeptic | Default: results are wrong | "Show me error bars" |
| Historian | Prior art | "This was done in 1972" |
| Methodologist | Statistical methodology | "Your test assumes normality" |
| Ethicist | Societal implications | "What are the downsides?" |
| Competitor | Novelty relative to existing work | "Minor mod of our 2023 paper" |
| Student | Clarity | "I don't understand section 3" |
| Dreamer | "What if you went further?" | "You stopped too early" |

---

## Architecture

```
                     ┌──────────────────────────────┐
                     │  Research Director            │
                     │  (orchestrator)               │
                     └────────┬─────────────────────┘
                              │
         ┌────────────────────┼─────────────────────────┐
         ▼                    ▼                          ▼
   ┌───────────┐    ┌────────────────┐    ┌──────────────────────┐
   │ Literature│    │ 6 Novelty      │    │ Gap Analyzer         │
   │ Scout ×5  │    │ Engines        │    │ + Methodology        │
   └───────────┘    └────────────────┘    └──────────────────────┘
                              │
         ┌────────────────────┼─────────────────────────┐
         ▼                    ▼                          ▼
   ┌─────────────────────────────────────────────────────────────┐
   │  Parallel Writing Swarm (5 agents + 41 Humanizer patterns)   │
   └──────────────────────────┬──────────────────────────────────┘
                              │
   ┌─────────────────────────────────────────────────────────────┐
   │  Verifier: Citations × Statistics × AI-Pattern Detection    │
   └──────────────────────────┬──────────────────────────────────┘
                              │
   ┌─────────────────────────────────────────────────────────────┐
   │  Adversarial Review: 10 reviewer personas (parallel)        │
   └──────────────────────────┬──────────────────────────────────┘
                              │
   ┌─────────────────────────────────────────────────────────────┐
   │  Style Auditor: Humanizer certification, em dash zero check │
   └──────────────────────────┬──────────────────────────────────┘
                              │
   ┌─────────────────────────────────────────────────────────────┐
   │  Formatter: LaTeX template, BibTeX, figures, PDF            │
   └─────────────────────────────────────────────────────────────┘
```

---

## For Developers

```bash
git clone https://github.com/argahv/sisyphus-academica.git
cd sisyphus-academica
pip install -e ".[dev]"
python -m pytest tests/ -v
```

### Running the full pipeline

```bash
# Requires a model provider (OpenAI, Anthropic, or any OpenAI-compatible API)
cp .env.example .env  # Add your API keys
bash install.sh
```

### Installing agents into OpenCode

```bash
bash install.sh
# Then: opencode → agent tab → select "research-director"
```

---

## Provider-Agnostic

Works with any OpenAI-compatible or Anthropic API. Edit `config/agent-config.json`:

```json
{
  "agents": {
    "research-director": {
      "model": "anthropic/claude-opus-4",
      "fallback_models": [{"model": "anthropic/claude-sonnet-4"}]
    }
  }
}
```

---

## Quality Gates

Every paper passes 5 gates. If any fails, it goes back to revision.

1. **Citation Verification** — Every reference checked against 2+ APIs. No exceptions.
2. **Statistical Audit** — Every p-value, effect size, sample size validated. No p-hacking.
3. **AI-Pattern Detection** — 41 Humanizer patterns scanned. Density < 2/1000 words.
4. **Style Audit** — Zero em dashes. Voice matches author's profile.
5. **Adversarial Review** — All 10 reviewer personas must recommend acceptance.

---

## Project Structure

```
sisyphus-academica/
├── orchestrator/          # Research Director agent
├── subagents/             # Writing pipeline agents
├── novelty-engines/       # 6 novelty generation engines
├── reviewers/             # 10 adversarial reviewer personas
├── skills/                # Standalone skill files (portable to any agent)
├── tools/                 # Python CLI toolchain
├── templates/             # LaTeX venue templates
├── config/                # Agent configuration
├── examples/siren-paper/  # Full pipeline output (13-page paper)
├── tests/                 # Python unit tests
└── docs/                  # GitHub Pages documentation
```

---

## License

MIT — see [LICENSE](LICENSE) for details.
