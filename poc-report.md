# PoC Report: sisyphus-academica

## Executive Summary

**Sisyphus Academica** is a multi-agent research paper writing system featuring 20+ specialized agents, 6 novelty engines, and 10 adversarial reviewers. The PoC successfully containerized the Python CLI using a UBI9 base image, built and pushed the image to Quay.io, and deployed it as Kubernetes Jobs on OpenShift. All three validation scenarios passed, confirming the tool installs and runs correctly in a containerized environment. The demo pipeline simulation completed end-to-end, exercising all six pipeline phases.

## Project Analysis

- **Repository:** https://github.com/argahv/sisyphus-academica
- **Fork:** https://github.com/aicatalyst-team/sisyphus-academica
- **Description:** A multi-agent research paper writing system with literature search, novelty generation, citation verification, adversarial review, and LaTeX output. Includes CLI tools for standalone use.
- **Classification:** llm-app (multi-agent research pipeline)

| Component | Language | Build System | ML Workload | Port |
|---|---|---|---|---|
| sisyphus-academica | Python 3.10+ | pip (setuptools) | No | None (CLI) |

- **Key Technologies:** Python, stdlib (urllib, json, xml, re), optional requests/scipy/matplotlib
- **License:** MIT

## Pipeline Execution

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#EE0000', 'primaryTextColor': '#fff', 'primaryBorderColor': '#A30000', 'lineColor': '#6A6E73', 'secondaryColor': '#F0F0F0', 'tertiaryColor': '#0066CC'}}}%%
flowchart LR
    A["1. Intake ✅"] --> B["2. Evaluate ✅"]
    B --> C["3. Fork ✅"]
    C --> D["4. PoC Plan ✅"]
    D --> E["5. Containerize ✅"]
    E --> F["6. Build ✅"]
    F --> G["7. Deploy ✅"]
    G --> H["8. Apply ✅"]
    H --> I["9. Test ✅"]
    I --> J["10. Report ✅"]
```

- **Intake:** Single Python CLI component, docker-compose.yml present, GitHub Actions CI
- **Evaluate:** Strategy areas: agentic-ai. Relationship: validates-platform-story
- **Fork:** https://github.com/aicatalyst-team/sisyphus-academica
- **Containerize:** Required fixing the build backend from `setuptools.backends._legacy:_Backend` (non-existent module) to `setuptools.build_meta`
- **Build:** Image built via OpenShift binary build, pushed to `quay.io/aicatalyst/sisyphus-academica:latest`
- **Deploy/Apply:** Three Kubernetes Jobs, all completed in under 7 seconds

## Test Results

| Scenario | Status | Duration | Details |
|---|---|---|---|
| cli-help | PASS | 0.17s | Shows all 5 CLI commands (demo, configure, search, verify, bibtex) |
| demo-run | PASS | 0.17s | Full 6-phase pipeline simulation completed (literature review, novelty generation, methodology, writing, verification, adversarial review) |
| module-import | PASS | 0.17s | Core tools (literature_client, citation_verifier) load successfully |

## Infrastructure Deployed

- **Namespace:** `poc-sisyphus-academica`
- **Container Image:** `quay.io/aicatalyst/sisyphus-academica:latest`
- **Base Image:** `registry.access.redhat.com/ubi9/python-312`
- **Resources:** 3 Kubernetes Jobs, 1 imagePullSecret
- **Resource Allocation:** 256Mi/250m requests, 512Mi/500m limits

## Recommendations

1. **Connect to literature APIs:** Configure Semantic Scholar and CrossRef API keys for live paper search
2. **LLM integration:** Point the agent orchestrator at a model served by Red Hat AI Inference Server for actual paper generation
3. **PVC for output:** Mount persistent storage for generated papers, BibTeX files, and LaTeX output
4. **Batch processing:** Convert to CronJobs for scheduled literature surveys

## Build Issues Encountered
1. **Retry 1:** `setuptools.backends._legacy` module not found (UBI setuptools version too old)
2. **Retry 2:** Same error with upgraded setuptools (module doesn't exist in any version)
3. **Fix:** Changed build backend from `setuptools.backends._legacy:_Backend` to standard `setuptools.build_meta` in pyproject.toml

## Appendix

- **PoC Plan:** [poc-plan.md](https://github.com/aicatalyst-team/sisyphus-academica/blob/autopoc-artifacts/poc-plan.md)
- **Dockerfile:** [Dockerfile.ubi](https://github.com/aicatalyst-team/sisyphus-academica/blob/main/Dockerfile.ubi)
- **K8s Manifests:** [kubernetes/](https://github.com/aicatalyst-team/sisyphus-academica/tree/main/kubernetes)
