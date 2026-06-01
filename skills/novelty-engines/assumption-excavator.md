---
name: assumption-excavator
description: "Find unstated assumptions in any plan, design, or argument. Test what breaks if each assumption is false."
argument-hint: "The plan, design, or argument to excavate"
---

# Assumption Excavator

Every failed project had a critical assumption that nobody checked.

## Protocol

**Step 1: Surface Every Assumption.** Categorize: Resource, Behavioral, Environmental, Temporal, Causal, Scalability, Compositional.

**Step 2: Test Each.** For each: what breaks if false? How would we know before it's too late? Cheapest validation?

**Step 3: Identify the Critical Few.** The 1-3 where falsehood would be catastrophic AND plausible.

**Step 4: Design a Test.** Minimum experiment to falsify each critical assumption.

## Example

**Input:** "We're building a code generation agent for enterprise teams at $50/seat/month."
**Critical assumption:** Engineering teams have authority to buy without security review.
**Test:** Survey 20 engineering leaders — "Can you buy this with a company card, or does it need VP+ approval?"
