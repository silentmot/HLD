---
name: Documentation Update
about: Update or add to HLD documentation
title: '[DOCS] '
labels: documentation
assignees: ''

---

## 📝 Documentation Change Summary

<!-- Brief description of what's being updated -->

## 📂 Files Modified

<!-- List the specific files being changed -->

- [ ] `docs/hld/XX-section-name.md`
- [ ] `docs/api/service-name/openapi.yaml`
- [ ] `docs/hld/diagrams/diagram-name.mmd`

## ✅ Pre-Submission Checklist

**GZANSP Compliance**:

- [ ] No assumptions made - all content sourced from requirements or specifications
- [ ] No banned terminology used (Enhanced, Advanced, Fixed, New, Old, etc.)
- [ ] Followed progressive disclosure pattern (Executive Summary + Technical Deep Dive)

**Content Quality**:

- [ ] Executive summary written for non-technical stakeholders
- [ ] Technical details complete and accurate
- [ ] No simplification of authoritative content
- [ ] Collapsible sections used appropriately for technical depth

**Diagrams & Visuals**:

- [ ] Updated diagrams (Mermaid/draw.io sources committed, not just images)
- [ ] Diagram syntax validated using preview tools
- [ ] All diagram references in markdown are correct

**Cross-References**:

- [ ] Internal links updated (to other HLD sections)
- [ ] External documentation links verified
- [ ] Section numbers referenced correctly
- [ ] Glossary additions for any new terms

**API Specifications**:

- [ ] OpenAPI specs validated with `redocly lint` (if API changes)
- [ ] API versioning policy followed (NO /v1/ paths)
- [ ] Request/response examples included
- [ ] Error responses documented

**Technical Accuracy**:

- [ ] Device protocols/hardware specs verified against vendor docs
- [ ] Integration patterns follow established architecture
- [ ] Data models align with ERD and domain model
- [ ] SLOs and metrics are measurable and realistic

**Review Requirements**:

- [ ] Appropriate reviewers assigned per CODEOWNERS
- [ ] Breaking changes highlighted and justified
- [ ] Implementation notes added where relevant

## 🔗 Related Issues/PRs

<!-- Link any related issues or pull requests -->

Closes #
Related to #

## 📋 Additional Context

<!-- Any additional information that reviewers should know -->

## 🧪 Testing Performed

- [ ] Documentation builds successfully locally (`mkdocs serve`)
- [ ] All internal links work
- [ ] Mermaid diagrams render correctly
- [ ] OpenAPI specs pass validation
- [ ] No broken images or assets

---

**For Reviewers**: Please verify compliance with the checklist and ensure no authoritative content has been simplified or omitted.
