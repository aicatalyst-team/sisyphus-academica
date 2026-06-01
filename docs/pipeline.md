---
title: Pipeline Phases
nav_order: 3
---

# Pipeline Phases

The paper pipeline runs 10 sequential phases. Verification and review phases can loop back for revision.

## Phase 0: Voice Calibration

**Input**: 2-3 paragraphs of the author's published writing
**Output**: Voice style profile (sentence length, vocabulary, paragraph patterns, punctuation)

The profile is loaded by every Writer agent. Writers match the author's voice at the sentence level.

## Phase 1: Literature Review

5 parallel scouts hit different sources:

| Scout | Source | Max |
|-------|--------|-----|
| 1 | arXiv OAI-PMH | 200 |
| 2 | Semantic Scholar | 100 |
| 3 | CrossRef | 50 |
| 4 | OpenAlex | 50 |
| 5 | Field-specific (NCBI, etc.) | varies |

Results are deduplicated by title similarity.

## Phase 1.5: Novelty Generation

All 6 novelty engines run in parallel, generating 50+ hypotheses scored by novelty × tractability. Top 3 become the paper's contribution.

| Engine | Angle | Output |
|--------|-------|--------|
| Contrarian | Invert field claims | 10 counter-hypotheses |
| Cross-Pollinator | Import from distant fields | Top 5 analogies |
| Assumption Excavator | Find unstated assumptions | 5 testable assumptions |
| Counterfactual Generator | Rewrite field history | 5 counterfactual histories |
| Paradox Sifter | Cross-reference limitations | Paradoxes + elephants |
| Heretic | 50 wild guesses from title alone | 50 hypotheses + haunting idea |

## Phase 2: Hypothesis Selection

Top hypotheses are selected (user input or automatic). Each includes primary claim, evidence base, gap filled, proposed approach.

## Phase 3: Methodology Design

Recommends correct statistical tests, performs power analysis, designs experimental protocol, flags confounds.

## Phase 4: Data Engineering

Writes Python analysis code, generates publication-ready figures (SciencePlots, 300 DPI, colorblind-safe), computes statistics.

## Phase 5: Parallel Writing

5 Writer subagents write simultaneously: Abstract, Introduction, Methods, Results, Related Work + Discussion. All 41 Humanizer patterns are hard constraints.

## Phase 6: Verification

3 parallel modules: Citation Verifier (2+ sources), Statistical Auditor (p-values, effect sizes, power), AI-Pattern Detector (41 patterns, density < 2/1000 words).

## Phase 7: Adversarial Review

10 reviewer personas (Theorist, Empiricist, Pragmatist, Skeptic, Historian, Methodologist, Ethicist, Competitor, Student, Dreamer) review independently. All 10 must recommend acceptance.

## Phase 8: Revision

Writers receive annotated critiques and revise. Loop continues until all 10 reviewers accept.

## Phase 9: Style Audit

Complete paper scanned for all 41 patterns. Em dash count must be ZERO. Pattern density < 1 per 2000 words. Voice must match author profile.

## Phase 10: Formatting → Submission

Formatter loads venue-specific LaTeX template, generates BibTeX from verified citations, embeds figures, compiles PDF. Output: `paper.tex`, `references.bib`, `paper.pdf`.
