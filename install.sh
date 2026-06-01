#!/bin/bash
# Sisyphus Academica — Interactive Installer
# Installs 25 agents into OpenCode with portable paths, prompts for config
#
# Usage: bash install.sh [--yes] [--dev] [--latex] [--check]
#   --yes     Skip all prompts, use defaults
#   --dev     Install Python dev dependencies
#   --latex   Verify LaTeX availability
#   --check   Validate installation

set -euo pipefail

SISYPHUS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OPENCODE_AGENTS="${OPENCODE_AGENTS:-$HOME/.config/opencode/agents}"
OPENCODE_SKILLS="${OPENCODE_SKILLS:-$HOME/.config/opencode/skills}"
OPENCODE_CONFIG="${OPENCODE_CONFIG:-$HOME/.config/opencode}"

SKIP_PROMPTS=false
for arg in "$@"; do [ "$arg" = "--yes" ] && SKIP_PROMPTS=true && break; done

echo "╔═══════════════════════════════════════════════════╗"
echo "║     Sisyphus Academica — Interactive Installer    ║"
echo "╚═══════════════════════════════════════════════════╝"
echo ""

# ------------------------------------------------------------------
# PROMPT helper — asks a question unless --yes mode
# ------------------------------------------------------------------
ask() {
    local var_name="$1" prompt="$2" default="${3:-}"
    if [ "$SKIP_PROMPTS" = true ]; then
        eval "$var_name=\"$default\""
        return
    fi
    local hint=""
    [ -n "$default" ] && hint=" [$default]"
    read -r -p "$prompt$hint: " input
    eval "$var_name=\"${input:-$default}\""
}

# ------------------------------------------------------------------
# CONFIRM helper — yes/no with default
# ------------------------------------------------------------------
confirm() {
    local prompt="$1" default="${2:-y}"
    if [ "$SKIP_PROMPTS" = true ]; then
        [ "$default" = "y" ] && return 0 || return 1
    fi
    local hint="[Y/n]"
    [ "$default" = "n" ] && hint="[y/N]"
    read -r -p "$prompt $hint " answer
    case "${answer:-$default}" in
        [yY]|[yY][eE][sS]) return 0 ;;
        *) return 1 ;;
    esac
}

# ==================================================================
# PHASE 0: INTERVIEW
# ==================================================================
echo "[0/6] Setting up your profile..."

ask AUTHOR_NAME "What is your name?" "${USER:-argahv}"

# Write name to CITATION.cff
if grep -q 'given-names: ""' "$SISYPHUS_DIR/CITATION.cff" 2>/dev/null; then
    FAMILY="${AUTHOR_NAME##* }"
    GIVEN="${AUTHOR_NAME% *}"
    [ -z "$GIVEN" ] && GIVEN="$FAMILY" && FAMILY=""
    [ -z "$FAMILY" ] && FAMILY="$GIVEN" && GIVEN=""
    sed -i "s/family-names: \".*\"/family-names: \"$FAMILY\"/" "$SISYPHUS_DIR/CITATION.cff"
    sed -i "s/given-names: \".*\"/given-names: \"$GIVEN\"/" "$SISYPHUS_DIR/CITATION.cff"
    echo "  ✓ CITATION.cff updated with name: $GIVEN $FAMILY"
else
    echo "  ✓ Name already set in CITATION.cff"
fi

# Q1: OpenCode?
if command -v opencode &>/dev/null; then
    echo "  ✓ OpenCode $(opencode --version 2>/dev/null | head -1) detected"
    HAS_OPENCODE=true
else
    echo "  ⚠ OpenCode not found (install from https://opencode.ai/docs)"
    HAS_OPENCODE=false
    if confirm "  Do you want to continue without OpenCode? (limited functionality)" "y"; then
        echo "  → Continuing with partial support (Python CLI tools only)"
    else
        echo "  → Aborting. Install OpenCode first, then re-run this script."
        exit 0
    fi
fi

# Q2: oh-my-openagent?
if [ -f "$OPENCODE_CONFIG/oh-my-openagent.json" ] || [ -f "$OPENCODE_CONFIG/oh-my-openagent.jsonc" ]; then
    echo "  ✓ oh-my-openagent detected — agents will integrate into omo ecosystem"
    HAS_OMO=true
else
    HAS_OMO=false
    if confirm "  Do you use oh-my-openagent? (for omo integration)" "n"; then
        echo "  → Install oh-my-openagent first, then re-run:"
        echo "    bunx oh-my-openagent install"
        echo "  → Continuing with standalone config"
    else
        echo "  → Using standalone configuration"
    fi
fi

# Q3: LLM provider
ask LLM_PROVIDER "Which LLM provider do you use? (anthropic/openai/both/9router/local)" "9router"
case "$LLM_PROVIDER" in
    anthropic) echo "  → Configuring agents for Anthropic Claude" ;;
    openai)    echo "  → Configuring agents for OpenAI GPT" ;;
    both)      echo "  → Configuring agents for Claude + GPT hybrid" ;;
    9router)   echo "  → Using default 9router provider" ;;
    local)     echo "  → Configuring for local models (quality may vary)" ;;
    *)         echo "  → Using: $LLM_PROVIDER" ;;
esac

# Q4: Semantic Scholar API key
ask SEMANTIC_SCHOLAR_KEY "Semantic Scholar API key? (leave blank to skip)" ""
if [ -n "$SEMANTIC_SCHOLAR_KEY" ]; then
    if [ -f "$SISYPHUS_DIR/.env" ]; then
        if grep -q 'SEMANTIC_SCHOLAR_API_KEY=' "$SISYPHUS_DIR/.env"; then
            sed -i "s/SEMANTIC_SCHOLAR_API_KEY=.*/SEMANTIC_SCHOLAR_API_KEY=$SEMANTIC_SCHOLAR_KEY/" "$SISYPHUS_DIR/.env"
        else
            echo "SEMANTIC_SCHOLAR_API_KEY=$SEMANTIC_SCHOLAR_KEY" >> "$SISYPHUS_DIR/.env"
        fi
    else
        cp "$SISYPHUS_DIR/.env.example" "$SISYPHUS_DIR/.env"
        sed -i "s/SEMANTIC_SCHOLAR_API_KEY=.*/SEMANTIC_SCHOLAR_API_KEY=$SEMANTIC_SCHOLAR_KEY/" "$SISYPHUS_DIR/.env"
    fi
    echo "  ✓ Semantic Scholar API key saved to .env"
else
    echo "  → Skipping API key (100 req/min rate limit applies)"
fi

# Q5: Voice sample
if [ -f "$SISYPHUS_DIR/data/voice-profile/sample.txt" ]; then
    if confirm "  Voice sample found. Use existing one?" "y"; then
        echo "  ✓ Using existing voice sample"
    else
        echo "  → Replace data/voice-profile/sample.txt with your writing"
    fi
else
    if confirm "  Do you have a writing sample for voice calibration?" "n"; then
        echo "  → Paste 2-3 paragraphs into data/voice-profile/sample.txt"
    else
        echo "  → Skipping voice calibration (neutral academic tone)"
    fi
fi

# Q6: LaTeX
if command -v pdflatex &>/dev/null; then
    echo "  ✓ LaTeX detected: $(pdflatex --version 2>/dev/null | head -1)"
    HAS_LATEX=true
elif command -v docker &>/dev/null; then
    echo "  ⚠ LaTeX not installed locally, but Docker is available"
    if confirm "  Use Docker for LaTeX compilation?" "y"; then
        HAS_LATEX=true
    else
        HAS_LATEX=false
    fi
else
    echo "  ⚠ LaTeX not found. Papers will output .tex only (no PDF)"
    HAS_LATEX=false
fi

echo ""

# ==================================================================
# PHASE 1: INSTALL AGENT FILE with portable path transformation
# ==================================================================
install_agent_file() {
    local src="$1"
    local basename="$(basename "$src")"
    local dest="$OPENCODE_AGENTS/$basename"

    if [ ! -f "$src" ]; then
        echo "  ⚠ Missing source: $src"
        return 1
    fi

    mkdir -p "$OPENCODE_AGENTS"
    sed \
        -e "s|/root/sisyphus-academica|$SISYPHUS_DIR|g" \
        -e "s|/root/\.config/opencode|$OPENCODE_CONFIG|g" \
        -e "s|/root/\.local/share/opencode|$HOME/.local/share/opencode|g" \
        -e "s|/tmp/opencode|/tmp/opencode|g" \
        "$src" > "$dest"

    echo "  ✓ $basename"
}

# ==================================================================
# PHASE 2: Transform config/agent-config.json
# ==================================================================
install_config() {
    local src="$SISYPHUS_DIR/config/agent-config.json"
    local dest="$OPENCODE_AGENTS/../agent-config.json"
    if [ ! -f "$src" ]; then
        echo "  ⚠ Missing config: $src"
        return
    fi
    mkdir -p "$OPENCODE_CONFIG"
    sed \
        -e "s|/root/sisyphus-academica|$SISYPHUS_DIR|g" \
        -e "s|/root/\.config/opencode|$OPENCODE_CONFIG|g" \
        -e "s|/root/\.local/share/opencode|$HOME/.local/share/opencode|g" \
        "$src" > "$dest"
    echo "  ✓ agent-config.json → $dest"
}

# ==================================================================
# PHASE 3: Model config based on provider choice
# ==================================================================
configure_models() {
    local config_file="$OPENCODE_CONFIG/agent-config.json"
    [ ! -f "$config_file" ] && return

    case "$LLM_PROVIDER" in
        anthropic)
            sed -i 's|"model": "9router/opencode-free"|"model": "anthropic/claude-sonnet-4"|g' "$config_file"
            sed -i 's|"model": "anthropic/claude-opus-4"|"model": "anthropic/claude-opus-4"|g' "$config_file"
            echo "  → Writers/reviewers set to Claude Sonnet 4"
            ;;
        openai)
            sed -i 's|"model": "9router/opencode-free"|"model": "openai/gpt-4o"|g' "$config_file"
            echo "  → All agents set to GPT-4o"
            ;;
        both)
            sed -i 's|"model": "9router/opencode-free"|"model": "anthropic/claude-sonnet-4"|g' "$config_file"
            echo "  → Writers/reviewers set to Claude Sonnet 4"
            echo "  → Edit config to add openai/gpt-4o for verification agents"
            ;;
        9router|*)
            echo "  → Using default 9router provider (no change needed)"
            ;;
    esac
}

# ==================================================================
# [1/6] Install Humanizer skill
# ==================================================================
echo "[1/6] Installing Humanizer skill..."
if [ ! -f "$OPENCODE_SKILLS/humanizer/SKILL.md" ]; then
    mkdir -p "$OPENCODE_SKILLS"
    if command -v git &>/dev/null; then
        git clone https://github.com/blader/humanizer.git "$OPENCODE_SKILLS/humanizer" 2>/dev/null || {
            echo "  ⚠ Could not clone humanizer. Install manually:"
            echo "    git clone https://github.com/blader/humanizer.git \$OPENCODE_SKILLS/humanizer"
        }
    else
        echo "  ⚠ git not found. Install manually:"
        echo "    git clone https://github.com/blader/humanizer.git \$OPENCODE_SKILLS/humanizer"
    fi
    echo "  ✓ Humanizer installed"
else
    echo "  ✓ Humanizer already exists"
fi

# ==================================================================
# [2/6] Install academic-humanizer skill
# ==================================================================
echo "[2/6] Installing academic-humanizer skill..."
mkdir -p "$OPENCODE_SKILLS/skill-academic-humanizer"
cp "$SISYPHUS_DIR/skills/skill-academic-humanizer.md" "$OPENCODE_SKILLS/skill-academic-humanizer/SKILL.md" 2>/dev/null || \
    echo "  ⚠ Could not copy academic-humanizer"
echo "  ✓ Academic Humanizer installed"

# ==================================================================
# [3/6] Install orchestrator agents (25 total)
# ==================================================================
echo "[3/6] Installing orchestrator agents (25 total)..."

install_agent_file "$SISYPHUS_DIR/orchestrator/research-director.md"
for f in "$SISYPHUS_DIR/subagents/"*.md; do install_agent_file "$f"; done
for f in "$SISYPHUS_DIR/novelty-engines/"*.md; do install_agent_file "$f"; done
for f in "$SISYPHUS_DIR/reviewers/"*.md; do install_agent_file "$f"; done

echo "  → All agents installed in $OPENCODE_AGENTS"

# ==================================================================
# [4/6] Install config with path transformation
# ==================================================================
echo "[4/6] Installing agent configuration..."
install_config
configure_models

# ==================================================================
# [5/6] Set up directories and tools
# ==================================================================
echo "[5/6] Setting up directories..."
chmod +x "$SISYPHUS_DIR/tools/"*.py 2>/dev/null || true
mkdir -p "$SISYPHUS_DIR/data" "$SISYPHUS_DIR/out/papers" "$SISYPHUS_DIR/out/figures"

# Dev dependencies (optional)
if echo "$@" | grep -q -- "--dev"; then
    echo ""
    echo "[Optional] Installing Python dependencies..."
    if command -v pip3 &>/dev/null; then
        pip3 install -r "$SISYPHUS_DIR/requirements.txt" 2>/dev/null || \
            echo "  ⚠ pip install failed (try: pip install -r requirements.txt)"
    else
        echo "  ⚠ pip3 not found."
    fi
fi

# ==================================================================
# [6/6] Validation
# ==================================================================
echo "[6/6] Validating installation..."

errors=0
expected=25
count=0
for f in "$SISYPHUS_DIR/orchestrator/"*.md "$SISYPHUS_DIR/subagents/"*.md \
         "$SISYPHUS_DIR/novelty-engines/"*.md "$SISYPHUS_DIR/reviewers/"*.md; do
    base=$(basename "$f")
    [ -f "$OPENCODE_AGENTS/$base" ] && count=$((count + 1))
done

echo "  Agents installed: $count / $expected"
[ "$count" -ge "$expected" ] && echo "  ✓ All agents present" || { echo "  ⚠ Missing agents"; errors=$((errors + 1)); }

# Check config installed
if [ -f "$OPENCODE_CONFIG/agent-config.json" ]; then
    echo "  ✓ Configuration installed"
else
    echo "  ⚠ Configuration missing"
    errors=$((errors + 1))
fi

# Check .env
if [ -f "$SISYPHUS_DIR/.env" ]; then
    echo "  ✓ .env configured"
else
    echo "  ⚠ .env not configured — run: cp .env.example .env && edit .env"
fi

echo ""
if [ "$errors" -eq 0 ]; then
    echo "  ✓ Validation PASSED"
else
    echo "  ⚠ $errors issue(s) found"
fi

echo ""
echo "╔═══════════════════════════════════════════════════╗"
echo "║     Sisyphus Academica — INSTALLED                ║"
echo "║                                                   ║"
echo "║  Profile: $AUTHOR_NAME"
echo "║  Provider: $LLM_PROVIDER"
echo "║  LaTeX: $([ "$HAS_LATEX" = true ] && echo yes || echo no)"
echo "║  OpenCode: $([ "$HAS_OPENCODE" = true ] && echo yes || echo no)"
echo "║                                                   ║"
echo "║  Next steps:                                      ║"
echo "║  1. Select research-director from agent tab       ║"
echo "║  2. Type: \"write a paper about [topic]\"           ║"
echo "║                                                   ║"
echo "║  Validate: bash install.sh --check                 ║"
echo "║  Docs: https://github.com/argahv/sisyphus-academica ║"
echo "╚═══════════════════════════════════════════════════╝"
