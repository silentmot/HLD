# **CLARIFICATIONS RECEIVED - Final HLD Template Plan**

## **Progressive Disclosure Decision: YES + Dual-Layer Structure**

**Recommendation**: Use **collapsible markdown sections** with **two-tier content**:

```markdown
## Section Title

### Executive Summary (Always Visible)
[2-3 paragraph overview for executives/regulators]

<details>
<summary><b>📋 Technical Deep Dive (Click to Expand)</b></summary>

[Comprehensive technical content with diagrams, tables, code samples]
- Sub-section A
- Sub-section B
- Detailed specifications
- Implementation notes

</details>
```

**Rationale**:

- ✅ **Executives**: Read summaries, skip technical details
- ✅ **Developers**: Expand all sections for full context
- ✅ **Single Document**: No need to maintain separate exec/technical versions
- ✅ **GitHub Pages**: Renders collapsible sections natively
- ✅ **PDF Export**: Can configure to show all content expanded

---

## **FINAL HLD TEMPLATE STRUCTURE**

### **File Structure (GitHub Repository)**

```lua
docs/
├── hld/
│   ├── README.md                                    # HLD Index + Quick Navigation
│   │
│   ├── 01-executive-summary.md                      # 3 pages
│   │   ├── Business Context & Objectives
│   │   ├── System Capabilities Overview
│   │   ├── ROI & KPIs
│   │   └── Regulatory Compliance Summary
│   │
│   ├── 02-system-overview.md                        # 4 pages
│   │   ├── Vision & Mission
│   │   ├── Scope & Boundaries
│   │   ├── Stakeholder Matrix
│   │   ├── Concurrent Operation Model ⚡ NEW
│   │   │   └── 10+ simultaneous trips handling
│   │   └── System Constraints
│   │
│   ├── 03-business-requirements.md                  # 4 pages
│   │   ├── Functional Workflows
│   │   ├── Pricing Models ⚡ NEW
│   │   │   ├── Gatepass Fee Only
│   │   │   ├── Gatepass + Per-Ton Fee
│   │   │   └── Completely Free Sites
│   │   ├── Vehicle Approval Process ⚡ NEW
│   │   ├── Use Case Diagrams
│   │   ├── Actor-Goal Table
│   │   └── BRS Traceability Matrix
│   │
│   ├── 04-domain-model.md                           # 5 pages ⬆️
│   │   ├── DDD Bounded Contexts
│   │   ├── Context Map
│   │   ├── Ubiquitous Language Glossary
│   │   ├── Aggregate Roots & Entities
│   │   ├── Domain Events Catalog ⚡ EXPANDED
│   │   │   ├── trip.initiated
│   │   │   ├── trip.weight_captured
│   │   │   ├── trip.completed
│   │   │   └── "ALL events are device events" principle
│   │   └── Value Objects
│   │
│   ├── 05-architecture-overview.md                  # 5 pages ⬆️
│   │   ├── Architectural Principles & Patterns
│   │   ├── C4 Model Diagrams
│   │   │   ├── Context (Level 1)
│   │   │   ├── Container (Level 2)
│   │   │   └── Component (Level 3) for critical services
│   │   ├── Real-Time Orchestration Patterns ⚡ NEW
│   │   │   ├── Event-Driven Architecture
│   │   │   ├── Concurrent Trip State Management
│   │   │   └── Sub-Second Response Requirements
│   │   ├── Deployment Topology
│   │   │   ├── Cloud (Kubernetes)
│   │   │   ├── Edge (On-Premises IPC)
│   │   │   └── Network Zones (Device/App/Management)
│   │   ├── Technology Stack Rationale
│   │   └── Architecture Decision Records (ADRs)
│   │
│   ├── 06-microservices-catalog.md                  # 6 pages ⬆️
│   │   ├── Service Inventory ⚡ USER-PROVIDED
│   │   │   ├── Trip Service (Orchestrator)
│   │   │   ├── Device Service (Drivers, Polling, Health)
│   │   │   ├── Vehicle Service (Registry, Identifiers)
│   │   │   ├── Contract Service (Authorization)
│   │   │   ├── User Service (Auth, RBAC)
│   │   │   ├── Payment Service (Fee Calculation)
│   │   │   ├── Reports Service (Compliance, Operations)
│   │   │   └── Inventory Service (Separate Context)
│   │   ├── Per-Service Deep Dive
│   │   │   ├── Responsibilities
│   │   │   ├── API Surface (OpenAPI links)
│   │   │   ├── Dependencies
│   │   │   ├── Data Ownership
│   │   │   ├── SLOs (Latency, Availability)
│   │   │   └── Scaling Strategy
│   │   ├── Service Mesh Diagram
│   │   ├── API Gateway Configuration
│   │   └── Inter-Service Communication Patterns
│   │
│   ├── 07-data-architecture.md                      # 5 pages ⬆️
│   │   ├── Core ERD ⚡ USER-PROVIDED
│   │   │   ├── users → contracts → vehicles → trips
│   │   │   ├── sites → zones → devices → events
│   │   │   └── Inventory calculations ⚡ NEW
│   │   │       └── Formula: Produced + Received - Dispatched
│   │   ├── Database Schemas (Detailed DDL)
│   │   ├── Data Flow Diagrams (DFD)
│   │   ├── Transaction Isolation Levels ⚡ NEW
│   │   │   └── Concurrent trip handling strategies
│   │   ├── Event Sourcing Patterns ⚡ NEW
│   │   ├── Data Retention & Archival (5-year policy)
│   │   ├── Data Residency (KSA compliance)
│   │   ├── Backup & Disaster Recovery
│   │   └── Cache Strategy (Redis)
│   │
│   ├── 08-integration-architecture.md               # 7 pages ⬆️⬆️
│   │   ├── Integration Landscape Diagram
│   │   ├── Device Protocols ⚡ EXPANDED
│   │   │   ├── Weighbridge Indicators (Telnet, M-Bus, Modbus TCP, Serial)
│   │   │   ├── LPR Cameras (RTSP, HTTP API)
│   │   │   ├── UHF RFID (Serial, TCP)
│   │   │   ├── QR Scanners (USB, Serial)
│   │   │   ├── Barrier Gates (Relay, TCP)
│   │   │   └── ZKBio CVSecurity (HTTP API, Polling)
│   │   ├── Device Integration Sequence ⚡ AUTHORITATIVE
│   │   │   └── [FULL SEQUENCE DIAGRAM FROM USER - NO SIMPLIFICATION]
│   │   ├── Channel-to-Zone Mapping Table ⚡ NEW
│   │   │   ├── "MGE-1" → MEG_1 (MAIN_GATE)
│   │   │   ├── "SEN-1" → SEN_1 (INBOUND_SCALE)
│   │   │   └── "SIT-1" → SIT_1 (OUTBOUND_SCALE)
│   │   ├── API Contracts ⚡ USER-PROVIDED
│   │   │   ├── POST /trips/initiate
│   │   │   ├── POST /events/weight
│   │   │   ├── POST /trips/complete
│   │   │   ├── GET /vehicles/{plate}
│   │   │   ├── GET /devices/{id}/health
│   │   │   └── POST /devices/events
│   │   ├── Vendor SDK Integration
│   │   ├── Government/SAP Endpoints
│   │   ├── Webhook Patterns
│   │   └── Error Handling & Retries
│   │
│   ├── 09-hardware-specifications.md                # 8 pages ⬆️⬆️
│   │   ├── Device Catalog with Procurement Details ⚡ USER-PROVIDED
│   │   │   ├── Weigh Indicators
│   │   │   │   ├── Avery Weigh-Tronix ZM510
│   │   │   │   │   ├── Part Refs: AWT35-501655, AWT15-501545
│   │   │   │   │   └── Options: Wireless Ethernet, Analog Output, Relay I/O
│   │   │   │   └── Utilcell MATRIX II
│   │   │   │       ├── Models: 89400 (analog), 89400D (digital)
│   │   │   │       └── Cards: 89405 RS-485, 89409 Ethernet
│   │   │   ├── LPR Cameras
│   │   │   │   ├── ZKTeco ProBG3000
│   │   │   │   └── Hikvision DS-TCG406-E
│   │   │   │       ├── Models: DS-TCG406-E/MPR/12V/PoE/2812
│   │   │   │       └── Accessories: Vertical Pole, Corner Mount
│   │   │   ├── Barrier Gates
│   │   │   │   ├── ZKTeco LPRS 4000
│   │   │   │   └── Hikvision DS-TMG520
│   │   │   │       └── Specs: 5M cycles, RS-485, IP54
│   │   │   ├── ZKTeco Stack
│   │   │   │   ├── ProBG3000, UHF5 Pro, UHF10 Pro
│   │   │   │   ├── LPRS 4000, InBio Pro 160
│   │   │   │   └── 3590EXT Weight Indicator
│   │   │   └── [USE HARDWARE TEMPLATE FROM ORIGINAL PLAN]
│   │   ├── Per-Zone Device Configuration Matrix ⚡ USER-PROVIDED
│   │   │   ├── MEG Zones: LPR + RFID + Barrier
│   │   │   ├── SEN Zones: LPR + RFID + Barrier + Weighbridge
│   │   │   └── SIT Zones: LPR + RFID + Barrier + Weighbridge
│   │   ├── Site Topology Diagrams (draw.io)
│   │   ├── Network Topology ⚡ USER-PROVIDED
│   │   │   ├── Segregated LANs (Device/App/Management)
│   │   │   ├── 802.1X, VLAN, Firewall Enforcement
│   │   │   └── [VLANs/Subnets - NOT SPECIFIED, defer to LLD]
│   │   ├── Cabling Diagrams
│   │   ├── Power Requirements & UPS
│   │   └── Vendor Contacts [DEFER - NOT PROVIDED]
│   │
│   ├── 10-edge-computing-design.md                  # 4 pages ⬆️
│   │   ├── Edge Server Specifications ⚡ USER-PROVIDED
│   │   │   ├── OS: Ubuntu LTS / RHEL
│   │   │   ├── Form Factor: 1U/2U Rackmount
│   │   │   ├── Specs: Redundant PSU, ECC RAM, Dual 10GbE
│   │   │   ├── Storage: Enterprise SSD/NVMe RAID
│   │   │   ├── Virtualization: KVM/VMware/Hyper-V
│   │   │   └── Windows Server VM (Vendor Middleware)
│   │   ├── Local Data Stack ⚡ USER-PROVIDED
│   │   │   ├── PostgreSQL (Transactional)
│   │   │   ├── MongoDB (IoT/Events)
│   │   │   ├── Encryption, Daily Backup, Restore Tests
│   │   │   └── Sync to Cloud Strategy
│   │   ├── Concurrent Event Processing ⚡ NEW
│   │   │   ├── Event Queue Management
│   │   │   ├── Priority Handling (Weight > Detection > Health)
│   │   │   └── Sub-Second Latency Requirements
│   │   ├── Offline Resilience
│   │   │   ├── Local Trip Validation
│   │   │   ├── Event Buffering Strategy
│   │   │   └── Conflict Resolution on Reconnect
│   │   ├── Edge-Cloud Sync Patterns
│   │   └── Security Hardening ⚡ USER-PROVIDED
│   │       ├── Firewall, Patch Management, RBAC, MFA
│   │       └── Audit Trail
│   │
│   ├── 11-security-compliance.md                    # 3 pages [DEFER TO LLD]
│   │   ├── RBAC Model ⚡ USER-PROVIDED
│   │   │   └── Roles: ADMIN, MODERATOR, OPERATOR, CLIENT, REGULATOR, FINANCE
│   │   ├── Authentication & Authorization ⚡ USER-PROVIDED
│   │   │   ├── SSO, JWT, Session Management
│   │   │   ├── Device Auth: API Keys / Certificates
│   │   │   └── Permission Matrix
│   │   ├── Encryption (Transit/Rest)
│   │   ├── Audit Trails (5-Year Retention)
│   │   ├── ISO Alignment (QMS)
│   │   ├── Data Residency (KSA)
│   │   ├── Compliance Checklist
│   │   └── Threat Model [DEFER TO LLD]
│   │
│   ├── 12-operational-design.md                     # 3 pages
│   │   ├── Observability Stack
│   │   │   ├── Metrics (Prometheus, Grafana)
│   │   │   ├── Logging (ELK/Loki)
│   │   │   ├── Tracing (Jaeger)
│   │   │   └── Device Health Monitoring
│   │   ├── SLOs & SLIs
│   │   │   ├── Trip Initiation: <1s P99
│   │   │   ├── Weight Capture: <500ms P99
│   │   │   ├── API Availability: 99.9%
│   │   │   └── Device Health Check: Every 30s
│   │   ├── Alerting Strategy
│   │   ├── Incident Response Playbooks
│   │   ├── Disaster Recovery Plan
│   │   └── Business Continuity (Edge Failover)
│   │
│   ├── 13-deployment-cicd.md                        # 2 pages [DEFER TO LLD]
│   │   ├── Kubernetes Architecture
│   │   │   ├── Namespaces (prod/staging/dev)
│   │   │   ├── Resource Quotas & Limits
│   │   │   └── Autoscaling Policies
│   │   ├── GitOps Workflow (ArgoCD/Flux)
│   │   ├── CI/CD Pipeline
│   │   │   ├── Build (Rust/Bun)
│   │   │   ├── Test (Unit/Integration/E2E)
│   │   │   ├── Security Scanning (Trivy, Snyk)
│   │   │   └── Deployment Stages
│   │   ├── Zero-Downtime Deployment
│   │   │   ├── Blue-Green Strategy
│   │   │   ├── Canary Releases
│   │   │   └── Rollback Procedures
│   │   └── Infrastructure as Code (Terraform)
│   │
│   ├── 14-api-contracts.md                          # 3 pages
│   │   ├── API Inventory ⚡ USER-PROVIDED
│   │   ├── OpenAPI Specifications (Per-Service)
│   │   ├── Versioning Policy (NO /v1/ paths)
│   │   ├── SDK Generation Strategy
│   │   ├── Breaking Change SLA
│   │   ├── Rate Limiting & Throttling
│   │   └── API Documentation Portal (Redocly/Swagger UI)
│   │
│   ├── 15-event-streams.md                          # 5 pages ⬆️
│   │   ├── Event Catalog ⚡ USER-PROVIDED
│   │   │   ├── Domain Events
│   │   │   │   ├── trip.initiated
│   │   │   │   ├── trip.weight_captured (30s correlation window)
│   │   │   │   └── trip.completed
│   │   │   └── Integration Events
│   │   │       ├── lpr_read (relay_result: open_barrier)
│   │   │       ├── weight.stable (Modbus TCP/Serial, polled)
│   │   │       ├── device.health_changed
│   │   │       └── zkbio.event (API poll, bearer token)
│   │   ├── Redis Streams Configuration
│   │   ├── Temporal Workflows ⚡ USER-PROVIDED
│   │   │   ├── TripWorkflow
│   │   │   │   ├── Steps: EntryDetection → AwaitInboundWeight → AwaitOutboundWeight → CompleteTrip
│   │   │   │   ├── Retry: Exponential backoff, max 5, jitter
│   │   │   │   ├── Hard SLA: 24h timeout
│   │   │   │   └── Compensation: emit trip.failed, freeze billing, audit
│   │   │   └── DevicePollingWorkflow
│   │   │       ├── Steps: Poll → Validate Stability → Upsert Health → Emit Events
│   │   │       ├── Circuit Breaker: Open on repeated IO errors
│   │   │       └── Ops Alert on Circuit Open
│   │   ├── Trip State Machine Diagram
│   │   │   └── INITIATED → WEIGHED_IN → WEIGHED_OUT → COMPLETED
│   │   ├── Event Ordering Guarantees
│   │   ├── Idempotency Patterns
│   │   └── Dead Letter Queues
│   │
│   ├── 16-reporting-analytics.md                    # 3 pages
│   │   ├── ETL Pipeline Architecture
│   │   ├── Time-Series Metrics (InfluxDB/TimescaleDB)
│   │   ├── Operational Dashboards
│   │   │   ├── Live Trip Monitoring
│   │   │   ├── Device Health Grid
│   │   │   ├── Site Throughput Metrics
│   │   │   └── Financial Summary (Per-Site Fees)
│   │   ├── Compliance Reports
│   │   │   ├── Government Reporting Integration
│   │   │   ├── 5-Year Audit Trail Access
│   │   │   └── SAP Export Formats
│   │   ├── Report Catalog
│   │   │   ├── Daily Trip Summary
│   │   │   ├── Monthly Contract Billing
│   │   │   ├── Device Uptime Report
│   │   │   └── Waste Diversion Metrics
│   │   └── Analytics Data Model
│   │
│   ├── 17-future-roadmap.md                         # 2 pages
│   │   ├── ML Integration Opportunities
│   │   │   ├── Predictive Maintenance (Device Failures)
│   │   │   ├── Waste Volume Forecasting
│   │   │   └── Fraud Detection (Weight Manipulation)
│   │   ├── Scaling Plans
│   │   │   ├── Multi-Region Expansion
│   │   │   ├── Horizontal Service Scaling
│   │   │   └── Database Sharding Strategy
│   │   ├── Feature Pipeline (Next 12 Months)
│   │   ├── Technical Debt Backlog
│   │   └── Capacity Forecast
│   │
│   └── 99-glossary.md                               # 2 pages
│       ├── A-Z Glossary
│       │   ├── C&D Waste
│       │   ├── Gatepass Fee
│       │   ├── LPR (License Plate Recognition)
│       │   ├── MEG/SEN/SIT Zones
│       │   ├── Telnet/M-Bus/Modbus
│       │   ├── Trip Lifecycle States
│       │   ├── UHF RFID
│       │   └── ZKBio CVSecurity
│       ├── Acronyms Reference
│       └── External Documentation Links
│
├── diagrams/
│   ├── c4-context.mmd
│   ├── c4-container.mmd
│   ├── c4-component-trip-service.mmd ⚡ NEW
│   ├── c4-component-device-service.mmd ⚡ NEW
│   ├── deployment-topology.mmd
│   ├── erd-core.mmd
│   ├── trip-state-machine.mmd
│   ├── device-integration-sequence.mmd ⚡ AUTHORITATIVE (from user)
│   ├── concurrent-trip-handling.mmd ⚡ NEW
│   ├── channel-zone-mapping.mmd ⚡ NEW
│   ├── temporal-workflows.mmd ⚡ NEW
│   ├── hardware-layout-3-gate-site.drawio
│   ├── hardware-layout-2-gate-site.drawio
│   ├── integration-landscape.drawio
│   ├── network-topology.drawio
│   └── scale-protocol-detail.drawio ⚡ NEW
│
└── api/
    ├── trip-service/
    │   └── openapi.yaml
    ├── device-service/
    │   └── openapi.yaml
    ├── vehicle-service/
    │   └── openapi.yaml
    ├── contract-service/
    │   └── openapi.yaml
    ├── user-service/
    │   └── openapi.yaml
    ├── payment-service/
    │   └── openapi.yaml
    ├── reports-service/
    │   └── openapi.yaml
    └── inventory-service/
        └── openapi.yaml
```

---

## **FINAL PAGE ALLOCATION**

| Section | Pages | Priority | Notes |
|---------|-------|----------|-------|
| 01 Executive Summary | 3 | P0 | Business alignment |
| 02 System Overview | 4 | P0 | Includes concurrency model |
| 03 Business Requirements | 4 | P1 | Pricing models, approvals |
| 04 Domain Model | 5 | P0 | **MAXIMUM DEPTH** - DDD contexts, events |
| 05 Architecture Overview | 5 | P0 | Real-time orchestration patterns |
| 06 Microservices Catalog | 6 | P0 | **MAXIMUM DEPTH** - All 8 services |
| 07 Data Architecture | 5 | P0 | ERD, transaction isolation, event sourcing |
| 08 Integration Architecture | 7 | P0 | **MAXIMUM DEPTH** - Device protocols, authoritative sequence |
| 09 Hardware Specifications | 8 | P0 | **MAXIMUM DEPTH** - Procurement + integration specs |
| 10 Edge Computing Design | 4 | P0 | Edge specs, concurrent event processing |
| 11 Security & Compliance | 3 | P2 | **DEFER TO LLD** |
| 12 Operational Design | 3 | P1 | SLOs, observability, DR |
| 13 Deployment & CI/CD | 2 | P2 | **DEFER TO LLD** |
| 14 API Contracts | 3 | P1 | OpenAPI specs, versioning |
| 15 Event Streams | 5 | P0 | **MAXIMUM DEPTH** - Temporal workflows, state machines |
| 16 Reporting & Analytics | 3 | P1 | Dashboards, compliance reports |
| 17 Future Roadmap | 2 | P2 | ML, scaling, capacity |
| 99 Glossary | 2 | P1 | Critical terminology |
| **TOTAL** | **74 pages** | | Comprehensive authoritative HLD |

---

## **DOCUMENTATION TOOLING - FINAL SETUP**

### **1. GitHub Repository + Pages**

- ✅ Markdown files with collapsible sections (`<details>` tags)
- ✅ GitHub Actions auto-publish to Pages on merge to `main`
- ✅ Material for MkDocs theme (clean, searchable, mobile-friendly)
- ✅ Auto-generated navigation from file structure

### **2. MkDocs Configuration**

```yaml
site_name: SWMS High-Level Design
theme:
  name: material
  features:
    - navigation.tabs
    - navigation.sections
    - navigation.expand
    - toc.integrate
    - search.suggest
  palette:
    - scheme: default
      primary: indigo
      accent: cyan

plugins:
  - search
  - pdf-export:
      combined: true
      combined_output_path: SWMS-HLD-v1.0.pdf
  - mermaid2

markdown_extensions:
  - pymdownx.details
  - pymdownx.superfences:
      custom_fences:
        - name: mermaid
          class: mermaid
  - admonition
  - tables
```

### **3. OpenAI Docs Chat Integration (Immediate)**

```html
<!-- Embed in GitHub Pages footer -->
<script>
  window.OpenAI = {
    apiKey: 'OPENAI_API_KEY',
    assistant: {
      id: 'asst_SWMS_HLD',
      instructions: 'You are a technical assistant for SWMS HLD. Answer based on the documentation repository. Never simplify or assume.',
      model: 'gpt-4-turbo'
    }
  };
</script>
<script src="https://cdn.openai.com/assistants/v1/embed.js"></script>
```

**Training Corpus**:

- All markdown files in `docs/hld/`
- All OpenAPI specs in `docs/api/`
- All diagram sources in `docs/diagrams/`
- User instructions: "Answer authoritatively. Never simplify. Cite section numbers."

### **4. API Documentation Portal (Redocly)**

```yaml
# redocly.yaml
apis:
  trip-service:
    root: docs/api/trip-service/openapi.yaml
  device-service:
    root: docs/api/device-service/openapi.yaml
  # ... all services

theme:
  openapi:
    tryItOut: true
    authPersistence: localStorage
```

**Deployment**: GitHub Action builds unified API portal → `api.swms.docs.example.com`

## **5. Version Control & Review Workflow**

```Markdown
# .github/CODEOWNERS
docs/hld/04-domain-model.md @architects @domain-experts
docs/hld/06-microservices-catalog.md @architects @backend-team
docs/hld/08-integration-architecture.md @architects @device-team
docs/hld/09-hardware-specifications.md @hardware-lead @procurement
docs/api/ @api-owners @backend-team
```

**PR Template Checklist**:

- [ ] Updated diagrams (Mermaid/draw.io sources committed)
- [ ] Glossary additions for new terms
- [ ] Cross-references updated (internal links)
- [ ] OpenAPI specs validated (`redocly lint`)
- [ ] Collapsible sections used for technical depth
- [ ] No simplification of authoritative content

---
