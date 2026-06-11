# PoC Plan: sisyphus-academica

## Project Classification
- **Type:** llm-app (multi-agent research pipeline with CLI tools)
- **Key Technologies:** Python, stdlib (urllib, json, xml), optional requests, matplotlib, scipy
- **ODH Relevance:** Validates agentic AI research workflows running as containerized tools on OpenShift

## PoC Objectives
1. Containerize the sisyphus-academica CLI with UBI images
2. Validate the demo command runs without API keys
3. Verify citation verification and literature search tools function in containerized environment

## Infrastructure Requirements
- **Resource Profile:** small (256Mi RAM, 250m CPU)
- **GPU Required:** no
- **Persistent Storage:** none
- **Deployment Model:** job (CLI tool)
- **Listens on Port:** false
- **Needs LLM API:** false (demo mode works without keys)

## Test Scenarios

### Scenario 1: cli-help
- **Description:** Verify the CLI installs and shows help
- **Type:** cli
- **Input:** academica
- **Expected:** Shows usage with demo, search, verify, bibtex commands
- **Timeout:** 30 seconds

### Scenario 2: demo-run
- **Description:** Run the interactive demo (no API keys required)
- **Type:** cli
- **Input:** academica demo
- **Expected:** Exits 0, generates a mini paper outline
- **Timeout:** 60 seconds

### Scenario 3: module-import
- **Description:** Verify core modules import without errors
- **Type:** cli
- **Input:** python -c "from sisyphus.tools.literature_client import search_all; from sisyphus.tools.citation_verifier import verify_citation; print('Core tools loaded')"
- **Expected:** Exits 0, prints success message
- **Timeout:** 15 seconds
