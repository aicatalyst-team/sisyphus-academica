---
title: Novelty Engines
nav_order: 5
---

# Novelty Engines

The novelty engines are the core differentiator. Each thinks from a completely different cognitive frame.

## The Contrarian

Reads the literature, extracts every "well-established" claim, inverts it.

| Original Claim | Inverted Hypothesis |
|----------------|-------------------|
| "X causes Y" | "Y causes X" or "Z causes both" |
| "Method A is optimal" | "Method A works for unrelated reasons" |
| "Dataset D supports generalization" | "Dataset D has systematic biases" |

**Output**: 10 counter-hypotheses ranked by `impact_if_true × plausibility`.

## The Cross-Pollinator

Imports solutions from 15 completely unrelated fields: astrodynamics, epidemiology, portfolio theory, thermodynamics, linguistics, ecology, economics, neuroscience, materials science, shipbuilding, music theory, urban planning, immunology, geology, philosophy of science.

**Output**: Top 5 cross-domain analogies with novelty and transferability scores.

## The Assumption Excavator

Extracts assumptions at 3 levels:
1. **Explicit** — stated in the paper ("We assume i.i.d. data")
2. **Implicit** — never stated but present ("The benchmark rewards the right thing")
3. **Foundational** — so basic the field doesn't state them ("Math can model this")

**Output**: Assumption tree + top 5 testable assumptions.

## The Counterfactual Generator

Builds the field's history as a DAG, identifies branching points, rewrites history. Example: "What if the Transformer had FAILED on WMT 2014?" → No BERT, no GPT-1, LSTM research continues.

**Output**: 5 counterfactual histories with traced consequences.

## The Paradox Sifter

Extracts every "Limitations" and "Future Work" sentence from the entire literature. Cross-references them to find contradictions, elephants in the room, and paradoxes.

**Output**: Paradoxes found, elephants identified, contradictions resolved.

## The Heretic (Crown Jewel)

Reads ONLY the title and abstract. Generates 50 wild hypotheses. Then reads the full paper. Finds the gap between what the paper IS and what it COULD HAVE BEEN.

50 hypotheses in 5 categories:
| # | Category |
|---|----------|
| 1-10 | Methodological |
| 11-20 | Theoretical |
| 21-30 | Empirical |
| 31-40 | Foundational |
| 41-50 | Wild cards |

**The Haunting Idea**: One hypothesis the authors should have explored but didn't. Novelty gap ≥ 8, tractability ≥ 5, impact ≥ 7, surprise ≥ 8.
