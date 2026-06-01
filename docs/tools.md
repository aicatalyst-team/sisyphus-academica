---
title: Tool Reference
nav_order: 7
---

# Tool Reference

## literature_client.py

Multi-source literature search aggregator.

```bash
python3 tools/literature_client.py "transformer efficiency" --output papers/literature.json
```

### Sources

| Source | Max Results |
|--------|-------------|
| arXiv | Up to 200 |
| Semantic Scholar | Up to 100 |
| CrossRef | Up to 50 |
| OpenAlex | Up to 50 |

### Output

```json
{
  "query": "transformer efficiency",
  "total_raw": 400,
  "total_unique": 310,
  "by_source": { "arxiv": 200, "semantic_scholar": 100, "crossref": 50, "openalex": 50 },
  "papers": [
    {
      "title": "Efficient Transformers: A Survey",
      "authors": ["Tay, Y.", "Dehghani, M."],
      "year": 2022,
      "citation_count": 450,
      "doi": "10.1145/3530811"
    }
  ]
}
```

### Arguments

| Arg | Description |
|-----|-------------|
| `query` | Search query (positional, required) |
| `-o, --output` | Output JSON file path |

## citation_verifier.py

Verifies citations against Semantic Scholar and CrossRef.

```bash
python3 tools/citation_verifier.py --findings papers/draft.json --output papers/verified.json
python3 tools/citation_verifier.py --citation "Attention is all you need"
```

### Process

1. Extract citations from `[bracket]` notation
2. Search Semantic Scholar
3. Search CrossRef
4. If found in 2+ sources: verified
5. If found in 0 sources: hallucinated (blocks submission)

### Arguments

| Arg | Description |
|-----|-------------|
| `-f, --findings` | Findings JSON file |
| `-o, --output` | Output verification report |
| `-c, --citation` | Verify a single citation string |
