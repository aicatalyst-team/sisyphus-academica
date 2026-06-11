# Deploying a multi-agent research pipeline on Red Hat OpenShift AI

## What is Sisyphus Academica?

Academic research paper writing involves a long chain of specialized tasks: literature review, hypothesis generation, methodology design, parallel writing across sections, citation verification, and adversarial peer review. [Sisyphus Academica](https://github.com/argahv/sisyphus-academica) orchestrates 20+ specialized agents to handle this pipeline, each with a distinct role: novelty engines that generate counter-hypotheses and cross-pollinate ideas across fields, writer agents that produce sections in parallel, and reviewer personas (skeptic, empiricist, methodologist, and seven others) that challenge the output before it reaches submission quality.

We containerized Sisyphus Academica's Python CLI with a Red Hat Universal Base Image (UBI) and deployed it on [Red Hat OpenShift AI](https://www.redhat.com/en/technologies/cloud-computing/openshift/openshift-ai) to validate whether a multi-agent research pipeline can run as a managed batch workload.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#EE0000', 'primaryTextColor': '#fff', 'primaryBorderColor': '#A30000', 'lineColor': '#6A6E73', 'secondaryColor': '#F0F0F0', 'tertiaryColor': '#0066CC'}}}%%
flowchart LR
    A["Literature<br/>Review"] --> B["Novelty<br/>Generation"]
    B --> C["Methodology<br/>Design"]
    C --> D["Parallel<br/>Writing"]
    D --> E["Citation<br/>Verification"]
    E --> F["Adversarial<br/>Review"]
    style A fill:#EE0000,color:#fff
    style B fill:#EE0000,color:#fff
    style C fill:#F0F0F0,color:#151515
    style D fill:#F0F0F0,color:#151515
    style E fill:#0066CC,color:#fff
    style F fill:#0066CC,color:#fff
```

## Why containerize a research pipeline?

Research teams at universities and corporate R&D labs currently run agent-based writing tools on individual workstations. This creates several problems: inconsistent environments, no audit trail, no resource governance, and no way to share the pipeline across a team. Moving the pipeline to OpenShift means it runs as a scheduled job with proper resource limits, output persistence, and access controls.

The CLI includes five standalone tools that work without any agent platform: literature search across arXiv, Semantic Scholar, CrossRef, and OpenAlex; citation verification against multiple databases; BibTeX generation from DOIs; and a demo mode that simulates the full pipeline without API keys.

## Containerizing with UBI

The project has a clean Python package structure with a pyproject.toml, but we hit one build issue worth documenting. The pyproject.toml specified a non-standard build backend (`setuptools.backends._legacy:_Backend`) that doesn't exist in any released version of setuptools. We fixed this by switching to the standard `setuptools.build_meta` backend.

The Dockerfile is minimal:

```dockerfile
FROM registry.access.redhat.com/ubi9/python-312

WORKDIR /opt/app-root/src
USER 0
COPY . .
RUN chown -R 1001:0 /opt/app-root

USER 1001
RUN pip install --no-cache-dir .

USER 0
RUN chgrp -R 0 /opt/app-root && chmod -R g=u /opt/app-root

USER 1001
ENTRYPOINT ["academica"]
CMD ["demo"]
```

We built using OpenShift's binary build strategy, which uploads source to the cluster and builds without needing a local container runtime.

## Deploying and testing

We deployed three Kubernetes Jobs, each validating a different aspect of the containerized tool:

| Scenario | Result | What it validates |
|---|---|---|
| CLI help | PASS | CLI installs correctly, all 5 commands registered |
| Demo pipeline | PASS | Full 6-phase simulation completes (literature, novelty, methodology, writing, verification, review) |
| Module import | PASS | Core tools (literature search, citation verification) import without errors |

All three jobs completed in under 7 seconds on standard compute nodes, using 256Mi memory and 250m CPU.

The demo pipeline output confirmed all six phases ran correctly, ending with the adversarial review panel delivering an 8.0/10 average score across 10 reviewer personas.

## What comes next

The containerized CLI is the foundation. The next steps to make this production-ready on [Red Hat OpenShift AI](https://www.redhat.com/en/technologies/cloud-computing/openshift/openshift-ai):

1. **Connect to inference endpoints.** Point the agent orchestrator at a model served by the Red Hat AI Inference Server for actual paper generation rather than simulated output.
2. **Add PersistentVolumeClaims.** Mount storage for generated papers, BibTeX databases, and LaTeX output that survives across job runs.
3. **Schedule with CronJobs.** Automate literature surveys on a weekly cadence, building a continuously updated reference library.
4. **Multi-user access.** Wrap the CLI in a lightweight API server so multiple researchers can submit paper-writing requests through a shared interface.

The full source, Dockerfile, and Kubernetes manifests are at [github.com/aicatalyst-team/sisyphus-academica](https://github.com/aicatalyst-team/sisyphus-academica).
