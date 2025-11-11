# Documentation Tooling Setup Guide

This guide explains the documentation infrastructure for the SWMS High-Level Design.

## 🚀 Quick Start

### Local Development

1. **Install dependencies**:

   ```bash
   pip install -r requirements.txt
   ```

2. **Run local documentation server**:

   ```bash
   mkdocs serve
   ```

   Visit <http://localhost:8000>

3. **Validate OpenAPI specs**:

   ```bash
   npm install -g @redocly/cli
   redocly lint
   ```

## 📦 Components

### 1. MkDocs with Material Theme

**Purpose**: Generate static documentation site from markdown files

**Configuration**: `mkdocs.yml`

**Features**:

- Progressive disclosure with collapsible sections
- Search functionality
- Mermaid diagram rendering
- PDF export capability
- Mobile-friendly responsive design

### 2. Redocly API Documentation

**Purpose**: Unified API documentation portal for all microservices

**Configuration**: `redocly.yaml`

**Features**:

- Interactive API console (Try It Out)
- Multi-language code samples (curl, JS, Python, C#)
- Authentication persistence
- API linting and validation

**Build API docs**:

```bash
redocly build-docs -o api-docs/index.html
```

### 3. OpenAI Documentation Assistant

**Purpose**: AI-powered chat assistant for documentation navigation

**Location**: `docs/overrides/partials/footer.html`

**Configuration**:

- Replace `OPENAI_API_KEY` with actual API key
- Assistant ID: `asst_SWMS_HLD`
- Model: GPT-4 Turbo

**Training Corpus**:

- All HLD markdown files
- All OpenAPI specifications
- All diagram sources

### 4. GitHub Actions Workflows

#### Deploy Documentation (`.github/workflows/deploy-docs.yml`)

- **Triggers**: Push to `main`, manual dispatch
- **Actions**:
  - Build MkDocs site
  - Validate OpenAPI specs
  - Deploy to GitHub Pages
  - Build Redocly API docs

#### Validate Documentation (`.github/workflows/validate-docs.yml`)

- **Triggers**: Pull requests to `main`
- **Actions**:
  - Validate MkDocs configuration
  - Lint OpenAPI specs with Redocly
  - Check for broken internal links
  - Enforce GZANSP compliance (banned terms)
  - Validate Mermaid diagram syntax
  - Verify progressive disclosure structure

### 5. Code Ownership (`.github/CODEOWNERS`)

**Purpose**: Automatic reviewer assignment for documentation changes

**Coverage**:

- Architecture team for core HLD documents
- Domain experts for domain model
- Device team for integration/hardware
- API owners for OpenAPI specs
- Service-specific teams for their APIs

### 6. Pull Request Template

**Purpose**: Ensure documentation quality through comprehensive checklist

**Checks**:

- GZANSP compliance
- Content quality standards
- Diagram updates
- Cross-reference accuracy
- API specification validation
- Technical accuracy
- Testing performed

## 🔧 Configuration Files

| File | Purpose |
|------|---------|
| `mkdocs.yml` | MkDocs site configuration |
| `redocly.yaml` | Redocly API docs configuration |
| `requirements.txt` | Python dependencies |
| `.github/CODEOWNERS` | Code ownership rules |
| `.github/PULL_REQUEST_TEMPLATE.md` | PR checklist |
| `.github/workflows/deploy-docs.yml` | Deployment automation |
| `.github/workflows/validate-docs.yml` | Quality validation |

## 📝 Documentation Standards

### Progressive Disclosure Pattern

All HLD documents must follow this structure:

```markdown
# Section Title

## Executive Summary (Always Visible)

[2-3 paragraph overview for executives/regulators]

<details>
<summary><b>📋 Technical Deep Dive (Click to Expand)</b></summary>

[Comprehensive technical content]
- Detailed specifications
- Code samples
- Diagrams
- Implementation notes

</details>
```

### GZANSP Compliance

**Banned Terms** (never use in documentation):

- Comprehensive, Enhanced, Advanced
- Corrected, Fixed, Implemented
- Future, Final, Improved, Upgraded
- Perfected, Complete, Newer
- Refined, Optimized, Best, Ideal
- Flawless, Optimal, Executive
- New, Old, Updated, Modified, Migrated

### API Versioning Policy

❌ **FORBIDDEN**: `/api/v1/...`, `/api/v2/...`

✅ **REQUIRED**: `/api/[module]/[resource]`

Example:

- `/api/trips/initiate` ✅
- `/api/v1/trips/initiate` ❌

## 🚢 Deployment

### GitHub Pages

Documentation is automatically deployed to GitHub Pages on merge to `main`.

**URL**: `https://<username>.github.io/HLD/`

### Redocly API Portal

API documentation is built separately and can be deployed to a custom domain.

**Recommended URL**: `api.swms.docs.example.com`

## 🧪 Testing Locally

### Test Documentation Build

```bash
mkdocs build --strict --verbose
```

### Test OpenAPI Specs

```bash
redocly lint
openapi-spec-validator docs/api/*/openapi.yaml
```

### Test Mermaid Diagrams

```bash
npm install -g @mermaid-js/mermaid-cli
mmdc -i docs/hld/diagrams/diagram-name.mmd -o test.png
```

## 🔍 Validation Checks

Before submitting a PR, ensure:

1. ✅ `mkdocs build --strict` passes
2. ✅ `redocly lint` passes
3. ✅ All internal links work
4. ✅ No banned terminology
5. ✅ Progressive disclosure structure present
6. ✅ Mermaid diagrams render correctly
7. ✅ OpenAPI specs validated
8. ✅ Executive summaries written

## 📞 Support

For issues with:

- **MkDocs**: Check `mkdocs.yml` configuration
- **OpenAPI**: Validate with Redocly CLI
- **Diagrams**: Test with Mermaid CLI
- **GitHub Actions**: Check workflow logs
- **OpenAI Assistant**: Verify API key and assistant ID

## 🔗 Resources

- [MkDocs Documentation](https://www.mkdocs.org/)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Redocly CLI](https://redocly.com/docs/cli/)
- [OpenAPI Specification](https://swagger.io/specification/)
- [Mermaid Syntax](https://mermaid.js.org/)
- [GZANSP Protocol](./updates.md)
