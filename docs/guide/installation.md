---
title: Installation Guide
nav_order: 0
---

# Sisyphus Academica — Installation Guide

**A self-coordinating swarm of 20+ specialized agents that produces publication-ready research papers with genuine novelty, zero hallucinated citations, and no detectable AI-written patterns.**

This guide has two audiences:

- **For Humans** — copy-paste a prompt to let an LLM agent handle the install
- **For LLM Agents** — step-by-step instructions to install, configure, and verify

---

## For Humans

**Strongly recommended: let an LLM agent install this for you.** The setup involves API key configuration, agent deployment across 25 specialized agents, voice profile calibration, and provider selection — humans fat-finger these. An LLM agent reads the full guide and walks every step correctly.

Paste this prompt into Claude Code, AmpCode, Cursor, or any agent:

```
Install and configure Sisyphus Academica by following the instructions here:
https://github.com/argahv/sisyphus-academica/blob/main/docs/guide/installation.md
```

---

## For LLM Agents

> **IMPORTANT: Use `curl` to fetch this file, NOT WebFetch.** WebFetch summarizes content and loses critical details like API key setup, agent count validation, and provider configuration. Always use:
>
> ```bash
> curl -fsSL https://raw.githubusercontent.com/argahv/sisyphus-academica/main/docs/guide/installation.md
> ```

If you are an LLM Agent helping a user install Sisyphus Academica, welcome. Follow these steps in order.

---

### Step 0: Interview the user

Ask these questions in order. Each answer affects config decisions downstream.

#### Q1: Do you already have OpenCode installed?

```bash
if command -v opencode &> /dev/null; then
    echo "OpenCode $(opencode --version) is installed"
else
    echo "Not installed"
fi
```

| If they say... | Then... |
|----------------|---------|
| **Yes, I have OpenCode** | Proceed to Q2. Agents install via `install.sh` into `~/.config/opencode/agents/`. |
| **No, I don't** | Ask which platform they use instead: Claude Code, Cursor, Codex CLI, or VS Code Copilot. Map to the support level below. Offer to install OpenCode if they want full support (ref: https://opencode.ai/docs). |

Platform support levels:

| Platform | Agent Deployment | Python CLI Tools | PDF Output |
|----------|-----------------|-----------------|------------|
| **OpenCode** (recommended) | Full — all 25 agents via `install.sh` | ✅ | ✅ via LaTeX |
| **Claude Code** | Manual — copy agent files to project | ✅ | ✅ via LaTeX |
| **Cursor** | Manual — copy to `.cursor/rules/` | ✅ | ✅ via LaTeX |
| **Codex CLI** | Not supported (no agent orchestration) | ✅ standalone | ✅ via LaTeX |
| **VS Code Copilot** | Not supported | ✅ standalone | ✅ via LaTeX |

> **Why OpenCode is recommended:** Sisyphus Academica's 25 agents are OpenCode-native — they use the `task()` delegation system, `permission` frontmatter, and `external_directory` access controls. Other platforms offer partial support at best.

#### Q2: Do you already have oh-my-openagent installed?

```bash
ls ~/.config/opencode/oh-my-openagent.json 2>/dev/null && echo "Yes" || echo "No"
```

| If they say... | Then... |
|----------------|---------|
| **Yes, I have omo** | Sisyphus Academica agents integrate into omo's existing agent ecosystem. Deploy via `install.sh` — agents appear alongside omo's 11 agents. Use omo's model config pattern (`oh-my-openagent.jsonc`). |
| **No, I don't** | Install as standalone OpenCode agents. Use sisyphus-academica's own `config/agent-config.json` for model config. |

#### Q3: Which LLM provider(s) do you have?

This is the most important question — it determines the model config for all 17 configurable agents.

> "Which LLM provider(s) do you have access to?
> 1. Anthropic (Claude) — Claude Opus 4+ recommended
> 2. OpenAI (GPT) — GPT-4o or GPT-5+
> 3. Both
> 4. 9router (OpenCode's default gateway)
> 5. Ollama or local models
> 6. GitHub Copilot (as provider proxy)
> 7. OpenRouter or other API gateway"

Model recommendation by agent role:

| Agent Role | Recommended Model | Budget Alternative |
|------------|------------------|-------------------|
| **Research Director** (orchestrator) | Claude Opus 4+ or GPT-5+ | Claude Sonnet 4+ |
| **Writer** (paper sections) | Claude Sonnet 4+ | GPT-4o |
| **Heretic** (novelty engine) | Claude Opus 4+ | GPT-5+ |
| **Contrarian** (novelty engine) | Claude Sonnet 4+ | GPT-4o |
| **Verifier** (citation audit) | GPT-4o+ | Claude Haiku |
| **Literature Scout** | GPT-4o or Claude Haiku | Any fast model |
| **Reviewers** (10 personas) | Claude Sonnet 4+ | GPT-4o |
| **Formatter** (LaTeX) | Any cheap model | GPT-4o mini |

Provider mapping:

| User says | Set in config |
|-----------|--------------|
| Anthropic only | `"model": "anthropic/claude-opus-4"` for writer/heretic, `"anthropic/claude-sonnet-4"` for scout/reviewers |
| OpenAI only | `"model": "openai/gpt-5.5"` for director/writer, `"openai/gpt-4o"` for scout/formatter |
| Both | Best of both: Claude for writing/novelty, GPT for verification/search |
| 9router | Default: `"model": "9router/opencode-free"` (already set) |
| Ollama/local | `"model": "ollama/llama-3.3-70b"` or similar. Note: smaller models significantly degrade paper quality. |

**For "Both" users — optimal split:**
- Research Director → Anthropic Claude (best orchestration)
- Writer → Anthropic Claude (best prose quality)
- Heretic / Contrarian → Anthropic Claude (best novel reasoning)
- Verifier → OpenAI GPT (best structured verification)
- Literature Scout → OpenAI GPT or fast Claude
- Reviewers (10) → Claude Sonnet (most nuanced)
- Formatter → any cheap model

**Must strongly warn, when user said they don't have Claude subscription: Sisyphus Academica's writing and novelty engines work best with Claude models. GPT models can produce good results but may require more revision rounds. Local models under 70B parameters will significantly degrade paper quality.**

#### Q4: Do you have a Semantic Scholar API key?

```bash
# Free API key at https://www.semanticscholar.org/product/api
# Without it: 100 requests/min rate limit
# With it: 1000 requests/min
```

| If they say... | Then... |
|----------------|---------|
| **Yes** | Set `SEMANTIC_SCHOLAR_API_KEY` in `.env` |
| **No** | Offer to help get one (free, 2-minute signup). If they skip, proceed without — literature search is rate-limited but functional. |

#### Q5: Do you use LaTeX for paper formatting?

| If they say... | Then... |
|----------------|---------|
| **Yes** | Check `pdflatex` is available. If not, offer to install TeX Live or configure Docker. |
| **No, I use Word/Overleaf/other** | Papers output as `.tex` only. Skip LaTeX verification. They can compile elsewhere. |

#### Q6: Do you have a writing sample for voice calibration?

| If they say... | Then... |
|----------------|---------|
| **Yes** | Ask them to paste 2-3 paragraphs of their published writing. Save to `data/voice-profile/sample.txt`. This calibrates all writer agents to match their voice. |
| **No** | Proceed with neutral academic tone. Voice calibration is optional but recommended for review-level quality. |

#### Summary of answers

After all questions, confirm with the user:

> "Here's what I'll configure:
> - Platform: [OpenCode / Other]
> - omo integration: [Yes / No]
> - LLM provider: [Anthropic / OpenAI / Both / Other]
> - Semantic Scholar API: [Configured / Skipped]
> - LaTeX: [Checked / Skipped]
> - Voice sample: [Provided / Skipped]
>
> Shall I proceed?"

---

## Step 1: Prerequisites

### Check OpenCode is installed (recommended platform)

```bash
if command -v opencode &> /dev/null; then
    echo "OpenCode $(opencode --version) is installed"
else
    echo "OpenCode is not installed."
    echo "Install it from: https://opencode.ai/docs"
fi
```

If OpenCode is not installed, offer to install it or suggest the user does so first.

### Check Python 3.10+

```bash
python3 --version
# Must be 3.10 or higher
```

### Check git

```bash
git --version
```

### Check LaTeX (optional, for PDF generation)

```bash
if command -v pdflatex &> /dev/null; then
    echo "pdflatex found: $(pdflatex --version | head -1)"
else
    echo "pdflatex not found — papers will output .tex only."
    echo "Install TeX Live or use Docker:"
    echo "  apt-get install texlive-latex-base texlive-fonts-recommended texlive-latex-extra"
    echo "  # or via Docker:"
    echo "  docker compose --profile latex up -d"
fi
```

---

## Step 2: Clone and install

### Clone the repository

```bash
git clone https://github.com/argahv/sisyphus-academica.git
cd sisyphus-academica
```

### Run the installer

```bash
bash install.sh
```

The installer will:
1. Install the Humanizer skill from GitHub
2. Install the academic-humanizer skill
3. Deploy all **25 agent files** into `~/.config/opencode/agents/` with path transformation (adapts from the repo's default paths to the user's actual install directory)
4. Make CLI tools executable
5. Create output directories

### Validate the installation

```bash
bash install.sh --check
```

Expected output:
```
Agents installed: 25 / 25
✓ All agents present
✓ Paths match current install directory
```

If agents are missing, re-run `bash install.sh`. The installer is idempotent.

---

## Step 3: Configure API keys

### Copy and fill the environment file

```bash
cp .env.example .env
```

Required keys to configure:

| Key | Required? | How to get |
|-----|-----------|------------|
| `SEMANTIC_SCHOLAR_API_KEY` | Recommended | Free at https://www.semanticscholar.org/product/api (increases rate limit from 100 to 1000 req/min) |
| `CROSSREF_EMAIL` | Recommended | Use your institutional email (increases CrossRef rate limit via polite pool) |

Edit `.env` with the user's preferred editor:

```bash
# Using the agent's preferred editor:
nano .env
# or
code .env
```

### Configure model provider

Edit `config/agent-config.json` to set the model provider. The default uses `9router/opencode-free`. For common providers:

**Anthropic Claude:**
```json
{
  "agents": {
    "research-director": {
      "model": "anthropic/claude-opus-4",
      "variant": "think",
      "fallback_models": [
        { "model": "anthropic/claude-sonnet-4" }
      ]
    }
  }
}
```

**OpenAI GPT:**
```json
{
  "agents": {
    "research-director": {
      "model": "openai/gpt-4o",
      "variant": "think",
      "fallback_models": []
    }
  }
}
```

Apply the same pattern across all 17 agent entries, or at minimum update:
- `research-director` (orchestrator)
- `writer` (paper sections)
- `verifier` (citation verification)
- `heretic` (novelty engine, crown jewel)

> **Strongly recommended:** Use Claude Opus 4+ or GPT-4o for the research-director and heretic agents. The novelty engines and reviewer personas benefit significantly from stronger models. Fast/cheap models can be used for `literature-scout` and `formatter`.

---

### Step 3b: Configure provider authentication

If the user chose OpenCode, configure provider authentication after setting the model config. Use an interactive terminal session for OAuth flows:

**Anthropic Claude:**
```bash
opencode auth login
# Interactive Terminal → Provider → Anthropic
# Interactive Terminal → Login method → Claude Pro/Max
# Complete OAuth flow in browser
# Verify success
```

**OpenAI GPT:**
```bash
opencode auth login
# Interactive Terminal → Provider → OpenAI
# Interactive Terminal → Login method → ChatGPT
# Complete OAuth flow in browser
```

**9router (default):** No auth needed — the 9router gateway handles authentication via its own API key.

**Ollama/local models:** No auth needed. Ensure the Ollama server is running locally.

> **Important:** If the user does not have a paid Claude or GPT subscription, warn them: Sisyphus Academica's writing and novelty engines work best with Claude/GPT. Free-tier models (Claude Haiku, GPT-4o-mini) will produce noticeably lower quality papers and may require 2-3x more revision rounds.

---

## Step 4: Voice calibration (recommended)

Create a voice profile so the system matches the author's writing style:

```bash
mkdir -p data/voice-profile
```

Ask the user to provide 2-3 paragraphs of their previously published writing:

> "Please paste 2-3 paragraphs of your published writing into `data/voice-profile/sample.txt`. This helps the writer agents match your voice. Academic writing preferred, but any professional writing works."

If the user doesn't have a sample, proceed without one — the system will use a neutral academic tone.

---

### Step 4b: Model families reference

Use this table to help the user understand which models work well for which agents:

| Agent Role | Recommended Model | Budget Alt | Why |
|------------|-----------------|------------|-----|
| **Research Director** (orchestrator) | Claude Opus 4+ or GPT-5+ | Claude Sonnet 4+ | Needs strongest reasoning to coordinate 25 agents |
| **Writer** (paper sections) | Claude Sonnet 4+ | GPT-4o | Claude produces more natural academic prose |
| **Heretic** (novelty engine) | Claude Opus 4+ | GPT-5+ | Needs creative + critical reasoning |
| **Contrarian / Cross-Pollinator** | Claude Sonnet 4+ | GPT-4o | Novelty engines need flexible reasoning |
| **Verifier** (citation audit) | GPT-4o+ | Claude Haiku | Structured verification favors GPT |
| **Literature Scout** | GPT-4o or Haiku | Any fast model | High volume, low complexity |
| **10 Reviewers** | Claude Sonnet 4+ | GPT-4o | Nuanced evaluation needs strong models |
| **Formatter** (LaTeX) | Any cheap model | GPT-4o-mini | Simple template filling |

**Model families by behavior:**

| Family | Behavior | Good For | Bad For |
|--------|----------|----------|---------|
| **Claude** (Opus, Sonnet, Haiku) | Instruction-following, structured output, natural prose | Writing, novelty, review | Speed (except Haiku) |
| **GPT** (4o, 4o-mini, 5+) | Explicit reasoning, principle-driven, fast | Verification, search, formatting | Creative writing |
| **9router** (default) | Gateway — routes to best available | All agents | None (pass-through) |
| **Local** (Ollama, 70B+) | Varies by model | Testing only | Paper quality degrades significantly |

---

## Step 5: Verify everything works

### Check all agents are registered

```bash
ls ~/.config/opencode/agents/ | wc -l
# Should show 25+ files (sisyphus-academica + any pre-existing agents)
```

### Check the agents have correct paths

```bash
grep -l 'research-director\|writer\|heretic' ~/.config/opencode/agents/*.md | wc -l
# Should show at least the core agents
```

### Check no residual hardcoded paths

```bash
bash install.sh --check
```

### Test a paper generation

Ask the user:

> "Ready to write a paper? Give me a topic and I'll walk through it. Example: 'transformer efficiency' or 'multi-agent reinforcement learning'."

Then in OpenCode, select "research-director" from the agent tab and type:
```
write a paper about [user's topic]
```

---

## Step 6: Post-installation

### Star the repository

Ask the user to star the repo if the installation was helpful:

```bash
gh api --silent --method PUT /user/starred/argahv/sisyphus-academica >/dev/null 2>&1 || true
```

### Known limitations to tell the user

| Limitation | Workaround |
|------------|------------|
| LaTeX venue templates are stubs (NeurIPS, ICML, ICLR, Nature, arXiv) | Add your own `.sty`/`.cls` files to `templates/<venue>/` |
| No PyPI package yet | Install via git clone only |
| Python CLI tools use stdlib `urllib` (no retries) | Manually retry on API errors |
| API keys needed for literature search | Sign up for free Semantic Scholar key |

### Tutorial for the user

Walk the user through their first use. Cover these surfaces:

**Modes (type naturally in chat):**

| Keyword | What it does |
|---------|--------------|
| `write a paper about [topic]` | Full pipeline: literature → novelty → writing → review → PDF |
| `research [topic]` | Literature review only (skips writing) |
| `review this paper` | Analyze a draft with all 10 adversarial reviewers |
| `improve section 3` | Rewrite a specific section with Humanizer constraints |

**Slash commands (Research Director agent):**

| Command | Purpose |
|---------|---------|
| `voice-calibrate` | Walk through setting up a voice profile |
| `check-api-keys` | Validate all configured API keys |
| `pipeline-status` | Show current pipeline progress |
| `explain [concept]` | Research director explains its reasoning |

**The 25 agents at your disposal:**

| Group | Agents | What they do |
|-------|--------|-------------|
| **Orchestrator** (1) | research-director | Conducts the entire pipeline |
| **Subagents** (8) | writer, verifier, style-auditor, literature-scout, formatter, gap-analyzer, methodology-designer, data-engineer | Core paper production |
| **Novelty Engines** (6) | heretic, contrarian, cross-pollinator, assumption-excavator, counterfactual-generator, paradox-sifter | Generate original hypotheses |
| **Reviewers** (10) | theorist, empiricist, pragmatist, skeptic, historian, methodologist, ethicist, competitor, student, dreamer | Adversarial review from 10 angles |

**Skills loaded automatically:**

| Skill | When it triggers |
|-------|-----------------|
| `humanizer` | Every writer agent — 30 anti-AI-writing patterns as hard constraints |
| `skill-academic-humanizer` | Every novelty engine and reviewer — 11 academic-specific patterns |

**Tell the user:**

1. **Just start writing:** In OpenCode, select "research-director" → type `write a paper about [topic]`. The pipeline handles everything.
2. **Want more control?** Run individual steps: `python3 tools/literature_client.py "topic" --output papers/lit.json`
3. **Customize models:** Each agent can use a different provider — edit `config/agent-config.json`
4. **Voice matters:** Provide a writing sample in `data/voice-profile/` for noticeably better results
5. **Need help?** Open an issue at https://github.com/argahv/sisyphus-academica/issues

### Uninstall

If the user no longer wants the installation:

```bash
# Remove all sisyphus-academica agents
rm ~/.config/opencode/agents/research-director.md
rm ~/.config/opencode/agents/data-engineer.md
rm ~/.config/opencode/agents/formatter.md
rm ~/.config/opencode/agents/gap-analyzer.md
rm ~/.config/opencode/agents/literature-scout.md
rm ~/.config/opencode/agents/methodology-designer.md
rm ~/.config/opencode/agents/style-auditor.md
rm ~/.config/opencode/agents/verifier.md
rm ~/.config/opencode/agents/writer.md
rm ~/.config/opencode/agents/assumption-excavator.md
rm ~/.config/opencode/agents/contrarian.md
rm ~/.config/opencode/agents/counterfactual-generator.md
rm ~/.config/opencode/agents/cross-pollinator.md
rm ~/.config/opencode/agents/heretic.md
rm ~/.config/opencode/agents/paradox-sifter.md
rm ~/.config/opencode/agents/competitor.md
rm ~/.config/opencode/agents/dreamer.md
rm ~/.config/opencode/agents/empiricist.md
rm ~/.config/opencode/agents/ethicist.md
rm ~/.config/opencode/agents/historian.md
rm ~/.config/opencode/agents/methodologist.md
rm ~/.config/opencode/agents/pragmatist.md
rm ~/.config/opencode/agents/skeptic.md
rm ~/.config/opencode/agents/student.md
rm ~/.config/opencode/agents/theorist.md

# Remove config file
rm -f ~/.config/opencode/agent-config.json

# Remove the repo
rm -rf sisyphus-academica
```

---

## Troubleshooting

| Problem | Likely cause | Fix |
|---------|--------------|-----|
| `ModuleNotFoundError: scienceplots` | Python deps not installed | `pip install -r requirements.txt` |
| `pdflatex: command not found` | LaTeX not installed | Install TeX Live or use Docker |
| `0 papers found` | API key missing or rate-limited | Configure `SEMANTIC_SCHOLAR_API_KEY` in `.env` |
| Agent delegation fails | Install may be incomplete | Run `bash install.sh --check` and re-install |
| Missing agent when running pipeline | Not all 25 agents installed | Re-run `bash install.sh` |
| Write permission denied | Hardcoded paths in agent files | Re-run `bash install.sh` which transforms paths |
