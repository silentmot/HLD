# SWMS High-Level Design Documentation

**Version:** 1.0
**Last Updated:** November 2025
**Status:** Living Document

---

## :material-clipboard-text: Quick Navigation

### Core Architecture

- [01. Executive Summary](01-executive-summary.md) - Business context, objectives, ROI, compliance
- [02. System Overview](02-system-overview.md) - Vision, scope, concurrent operation model
- [05. Architecture Overview](05-architecture-overview.md) - C4 diagrams, real-time orchestration, ADRs

### Domain & Services

- [04. Domain Model](04-domain-model.md) - DDD bounded contexts, domain events, ubiquitous language
- [06. Microservices Catalog](06-microservices-catalog.md) - All 8 services with deep dive per service

### Data & Integration

- [07. Data Architecture](07-data-architecture.md) - ERD, event sourcing, transaction isolation
- [08. Integration Architecture](08-integration-architecture.md) - Device protocols, authoritative sequences
- [15. Event Streams](15-event-streams.md) - Event catalog, Temporal workflows, state machines

### Hardware & Edge

- [09. Hardware Specifications](09-hardware-specifications.md) - Device catalog with procurement details
- [10. Edge Computing Design](10-edge-computing-design.md) - Edge servers, concurrent event processing

### Operations & Compliance

- [11. Security & Compliance](11-security-compliance.md) - RBAC, authentication, encryption
- [12. Operational Design](12-operational-design.md) - Observability, SLOs, incident response
- [13. Deployment & CI/CD](13-deployment-cicd.md) - Kubernetes, GitOps, zero-downtime

### Business & Requirements

- [03. Business Requirements](03-business-requirements.md) - Pricing models, vehicle approval workflows
- [14. API Contracts](14-api-contracts.md) - OpenAPI specs, versioning policy
- [16. Reporting & Analytics](16-reporting-analytics.md) - Dashboards, compliance reports

### Reference

- [17. Future Roadmap](17-future-roadmap.md) - ML opportunities, scaling plans
- [99. Glossary](99-glossary.md) - A-Z terminology, acronyms

---

## :material-target: Document Purpose

This High-Level Design (HLD) document serves as the **authoritative architectural blueprint** for the Smart Waste Management System (SWMS). It is designed for:

- **Executives & Regulators**: Executive summaries provide business context without technical depth
- **Architects & Developers**: Technical deep dives provide comprehensive implementation guidance
- **Procurement & Operations**: Hardware specifications and operational procedures
- **Compliance Officers**: Security, audit trails, and regulatory alignment

---

## :material-chart-box: System at a Glance

| Aspect | Description |
|--------|-------------|
| **Architecture** | Event-driven microservices with edge computing |
| **Concurrency** | 10+ simultaneous trips per site |
| **Services** | 8 core microservices (Trip, Device, Vehicle, Contract, User, Payment, Reports, Inventory) |
| **Devices** | LPR cameras, UHF RFID, weighbridges, barrier gates, QR scanners |
| **Protocols** | Telnet, M-Bus, Modbus TCP, Serial, RTSP, HTTP API |
| **Edge** | Ubuntu/RHEL servers with PostgreSQL + MongoDB + Redis |
| **Cloud** | Kubernetes (EKS/GKE/AKS), managed PostgreSQL, Redis, S3 |
| **Orchestration** | Temporal workflows with exponential backoff retry |
| **Compliance** | 5-year audit retention, KSA data residency, ISO QMS alignment |

---

## :material-office-building: Documentation Structure

### Progressive Disclosure Pattern

Each section follows a **two-tier structure**:

```markdown
## Section Title

### Executive Summary (Always Visible)
[2-3 paragraph overview for executives/regulators]

<details>
<summary><b>:material-clipboard-text: Technical Deep Dive (Click to Expand)</b></summary>

[Comprehensive technical content with diagrams, tables, code samples]
- Sub-section A
- Sub-section B
- Detailed specifications
- Implementation notes

</details>
```

**Benefits**:

- :material-check-circle: Executives read summaries, skip technical details
- :material-check-circle: Developers expand all sections for full context
- :material-check-circle: Single document - no separate exec/technical versions
- :material-check-circle: GitHub Pages renders collapsible sections natively
- :material-check-circle: PDF export shows all content expanded

---

## :material-ruler-square: Page Allocation

| Section | Pages | Priority | Focus |
|---------|-------|----------|-------|
| 01 Executive Summary | 3 | P0 | Business alignment |
| 02 System Overview | 4 | P0 | Concurrency model |
| 03 Business Requirements | 4 | P1 | Pricing, approvals |
| 04 Domain Model | 5 | P0 | **MAXIMUM DEPTH** - DDD contexts |
| 05 Architecture Overview | 5 | P0 | Real-time orchestration |
| 06 Microservices Catalog | 6 | P0 | **MAXIMUM DEPTH** - All 8 services |
| 07 Data Architecture | 5 | P0 | ERD, transaction isolation |
| 08 Integration Architecture | 7 | P0 | **MAXIMUM DEPTH** - Device protocols |
| 09 Hardware Specifications | 8 | P0 | **MAXIMUM DEPTH** - Procurement |
| 10 Edge Computing Design | 4 | P0 | Concurrent event processing |
| 11 Security & Compliance | 3 | P2 | DEFER TO LLD |
| 12 Operational Design | 3 | P1 | SLOs, observability |
| 13 Deployment & CI/CD | 2 | P2 | DEFER TO LLD |
| 14 API Contracts | 3 | P1 | OpenAPI specs |
| 15 Event Streams | 5 | P0 | **MAXIMUM DEPTH** - Temporal workflows |
| 16 Reporting & Analytics | 3 | P1 | Dashboards |
| 17 Future Roadmap | 2 | P2 | ML, scaling |
| 99 Glossary | 2 | P1 | Terminology |
| **TOTAL** | **74 pages** | | Comprehensive authoritative HLD |

---

## :material-link-variant: Related Resources

- **API Documentation Portal**: [Redocly Portal](../api/) - Interactive OpenAPI specs
- **Diagrams**: [Diagram Sources](../diagrams/) - Mermaid & draw.io files
- **GitHub Repository**: [HLD Repository](https://github.com/silentmot/HLD)
- **GitHub Pages Site**: [Published Documentation](https://silentmot.github.io/HLD)

---

## :material-file-document-edit: Document Conventions

### Terminology

- **MUST/SHALL**: Mandatory requirement
- **SHOULD**: Strong recommendation
- **MAY/CAN**: Optional
- **:material-new-box: NEW**: Content added in latest revision
- **:material-arrow-expand-up: EXPANDED**: Expanded section

### Diagrams

- **Mermaid**: For architecture, sequence, state diagrams (renders in browser)
- **draw.io**: For complex hardware topology, network diagrams

### Code Blocks

- **YAML**: Configuration examples
- **TypeScript**: API contracts, interfaces
- **SQL**: Database schemas
- **Bash**: Deployment scripts

---

## :material-handshake: Contributing

### Review Process

1. Fork repository
2. Create feature branch (`git checkout -b docs/section-name`)
3. Follow PR template checklist
4. Request review from CODEOWNERS
5. Address feedback
6. Merge to `main` triggers auto-publish to GitHub Pages

### PR Checklist

- [ ] Updated diagrams (Mermaid/draw.io sources committed)
- [ ] Glossary additions for new terms
- [ ] Cross-references updated (internal links)
- [ ] OpenAPI specs validated (`redocly lint`)
- [ ] Collapsible sections used for technical depth
- [ ] No simplification of authoritative content

---

## :material-email: Contacts

- **Architecture Team**: <architects@swms.example.com>
- **Domain Experts**: <domain-experts@swms.example.com>
- **Hardware Lead**: <hardware-lead@swms.example.com>
- **API Owners**: <api-owners@swms.example.com>

---

**Last Generated**: November 2025
**Document Control**: Version controlled via Git, published via GitHub Actions
