# Architecture

## High-Level Diagram

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

## Component Roles

| Component | Role |
|-----------|------|
| **Research Director** | Conducts the full 10-phase pipeline. Delegates work. Never writes. |
| **Literature Scout** | Searches 500+ papers from arXiv, Semantic Scholar, CrossRef, OpenAlex |
| **Gap Analyzer** | Identifies genuine research gaps from the literature corpus |
| **6 Novelty Engines** | Generate hypotheses from 6 different cognitive frames |
| **Methodology Designer** | Selects correct statistical tests, runs power analysis |
| **Data Engineer** | Writes analysis code, generates publication-ready figures |
| **5 Writers** | Write paper sections in parallel under 41 Humanizer constraints |
| **Verifier** | 3-module check: citations, statistics, AI-patterns |
| **10 Reviewers** | Adversarial review from 10 distinct personas |
| **Style Auditor** | Final certification: zero AI-isms, zero em dashes |
| **Formatter** | LaTeX compilation, BibTeX generation, PDF output |

## File Layout

```
sisyphus-academica/
├── orchestrator/          # Research Director agent
├── subagents/             # 8 core pipeline agents
├── novelty-engines/       # 6 novelty generation agents
├── reviewers/             # 10 adversarial reviewer personas
├── skills/                # Academic Humanizer skill
├── tools/                 # Python CLI toolchain
├── templates/             # LaTeX venue templates
├── config/                # Agent configuration
├── data/                  # Research memory + voice profiles
├── out/                   # Generated papers and figures
├── tests/                 # Python tool tests
└── examples/              # Pipeline output examples
```

## Agent Communication

Agents communicate through files on disk. The Research Director writes a task specification, the subagent reads it, does its work, writes results. No shared state. Each agent file is self-contained with all instructions, output format, and constraints.
