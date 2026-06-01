---
name: paradox-sifter
description: "Cross-reference every 'Limitations' section across papers on the same topic to find contradictions and ignored tensions."
argument-hint: "Topic or set of papers to analyze"
---

# Paradox Sifter

Every paper has a Limitations section. Nobody cross-references them.

## Protocol

**Step 1: Collect Limitations.** Find 5-10 papers. Extract exact limitation statements.

**Step 2: Cross-Reference.** For each pair: do they contradict? Do they ignore each other? Do they compound?

**Step 3: Classify.** Direct contradiction, Mutual ignorance, Hidden dependency, Escalation.

**Step 4: Identify Richest Paradox.** Highest ignored duration × impact × testability.

## Example

**Topic:** "Chain-of-Thought Prompting"
**Paradox found:** Wei et al. (2022) claims CoT only works at ≥100B parameters. Kojima et al. (2022) shows zero-shot CoT works at 7B. Both published same year, neither cites the other's limitation. Ignored for 3+ years.
**Resolution experiment:** Few-shot CoT vs zero-shot CoT at 1B-100B across 10 tasks. Find the crossover point.
