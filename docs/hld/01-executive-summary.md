# SWMS High-Level Design Document
<!--markdownlint-disable-file-->
## Section 01: Executive Summary

---

## Document Control

| Version | Date | Author | Status |
|---------|------|--------|--------|
| 0.9 | 2025-11-10 | System Architecture Team | Draft - In Review |

**Document Classification**: Internal - Confidential
**Audience**: Executive Leadership, Board of Directors, Regulators, Strategic Partners, Investors
**Purpose**: Business alignment and strategic decision-making reference

---

## 1.1 Business Context & Strategic Imperative

The Kingdom of Saudi Arabia is experiencing unprecedented construction and urban development growth, generating millions of tons of Construction & Demolition (C&D) waste annually. Traditional landfill-based disposal creates environmental burdens, economic inefficiencies, and regulatory compliance challenges. The **Smart Waste Management System (SWMS)** represents a digital transformation initiative to modernize C&D waste recycling operations across multiple facilities, supporting Vision 2030's sustainability objectives and circular economy principles.

**SWMS** is an enterprise-grade platform that fully automates recycling facility operations through intelligent device integration, real-time trip orchestration, and data-driven compliance reporting. The system eliminates manual processes, reduces operational costs, and provides unprecedented visibility into waste diversion metrics critical for environmental impact reporting and regulatory submissions.

<details>
<summary><b>:material-clipboard-text: Strategic Context Deep Dive (Click to Expand)</b></summary>

### Market Opportunity

**C&D Waste Market Dynamics in KSA:**

- **Annual Volume**: Estimated 15-20 million tons of C&D waste generated annually
- **Current Diversion Rate**: <20% (industry benchmark)
- **Target Diversion Rate**: 80-90% through advanced recycling
- **Economic Value**: Recycled materials (crushed concrete, aggregates, metals) represent significant revenue streams
- **Regulatory Pressure**: Increasing government mandates for waste diversion and environmental reporting

**Business Model Evolution:**
SWMS enables three distinct operational models to accommodate diverse customer segments:

1. **Gatepass Fee Model**: Fixed entry fee per vehicle, ideal for high-volume contractors with predictable waste streams
2. **Gatepass + Per-Ton Model**: Hybrid pricing combining entry fee with weight-based charges, suitable for mixed-use customers
3. **Completely Free Model**: Zero-fee operations supported by government subsidies or strategic partnerships, maximizing waste diversion for public benefit

### Digital Transformation Objectives

**From Manual to Automated Operations:**

| **Legacy Process** | **SWMS Automation** | **Impact** |
|-------------------|---------------------|------------|
| Manual vehicle registration at gate | Automatic LPR/RFID detection (<1s) | 95% faster entry processing |
| Paper-based weight tickets | Real-time digital trip tracking | Zero paper waste, instant data access |
| Manual scale operations | Automated weight capture via Telnet/M-Bus | Eliminates human error, 24/7 operations |
| Excel-based billing | Automated fee calculation and invoicing | 80% reduction in billing disputes |
| Quarterly compliance reports | Real-time regulatory dashboards | Continuous compliance visibility |

**Strategic Enablers:**

- **Operational Excellence**: Sub-second response times for device events, supporting ≥100 concurrent trips per site
- **Data-Driven Insights**: Real-time analytics on waste volumes, diversion rates, equipment utilization, and revenue per facility
- **Scalability**: Cloud-native architecture supports expansion from pilot sites to nationwide network
- **Competitive Advantage**: First-mover advantage in digitized C&D recycling infrastructure in the region

### Stakeholder Value Proposition

**For Facility Operators:**

- Reduce operational costs by 40-60% through automation
- Increase throughput capacity by 3-4x without additional headcount
- Eliminate manual errors in weight measurement and billing
- Real-time visibility into device health and maintenance needs

**For Customers (Construction Companies, Contractors):**

- Seamless entry/exit experience with automatic vehicle recognition
- Transparent pricing with instant digital receipts
- Historical trip data for project cost tracking
- Self-service portal for vehicle registration and trip history

**For Regulators & Government:**

- Auditable 5-year data retention for compliance verification
- Standardized reporting formats for waste diversion metrics
- Real-time access to facility operations for oversight
- Environmental impact tracking aligned with Vision 2030 KPIs

**For Executive Leadership:**

- Unified dashboard for multi-site performance monitoring
- Predictive analytics for capacity planning and expansion decisions
- Financial transparency with per-site profitability analysis
- Risk mitigation through automated compliance and audit trails

</details>

---

## 1.2 System Capabilities Overview

SWMS is a **hybrid distributed platform** combining cloud microservices, on-premises edge computing, and physical device integration to deliver a fully automated C&D waste recycling facility management solution. The system operates across three architectural tiers:

**Core Capabilities:**

1. **Automated Trip Orchestration**: Vehicles are detected, weighed, and processed through a 4-stage lifecycle without manual intervention (Entry → Inbound Scale → Disposal → Outbound Scale)

2. **Real-Time Concurrent Operations**: Handles 10+ simultaneous trips across multiple zones (3 main gates, 6 scales) within sub-second latency requirements

3. **Multi-Protocol Device Integration**: Seamlessly connects weighbridge indicators (Telnet, M-Bus, Modbus), LPR cameras (RTSP/HTTP), RFID readers, QR scanners, and barrier gates from multiple vendors

4. **Intelligent Weight Correlation**: Automatically matches vehicle identifications with weight measurements across entry/exit scales using event-driven correlation windows

5. **Flexible Pricing Engine**: Supports three distinct billing models (Gatepass, Gatepass+PerTon, Free) with automated fee calculation and invoice generation

6. **Edge Resilience**: On-site edge servers maintain operations during network outages, with automatic synchronization upon reconnection

<details>
<summary><b>:material-clipboard-text: Technical Capabilities Deep Dive (Click to Expand)</b></summary>

### Functional Capability Matrix

| **Capability Domain** | **Features** | **Business Value** |
|-----------------------|--------------|-------------------|
| **Vehicle Management** | • Automated vehicle registration with approval workflow<br>• Multi-identifier support (License Plate, UHF RFID Tag, QR Code)<br>• Contract linkage and authorization validation<br>• Vehicle allowance limits enforcement | • Reduces gate processing time from 5+ minutes to <10 seconds<br>• Eliminates unauthorized vehicle access<br>• Streamlines customer onboarding |
| **Trip Automation** | • Zero-touch trip initiation upon vehicle detection<br>• State machine-driven lifecycle (INITIATED → WEIGHED_IN → WEIGHED_OUT → COMPLETED)<br>• Real-time trip correlation across entry/exit scales<br>• Auto-completion upon exit weight capture | • Eliminates manual ticket generation<br>• Prevents incomplete trip fraud<br>• Provides instant trip status visibility |
| **Weight Measurement** | • Dual-protocol scale integration (Telnet primary, M-Bus backup)<br>• Weight stability validation before capture<br>• Net weight calculation (Entry Weight - Exit Weight)<br>• Tamper detection through statistical anomaly analysis | • 99.9% weight measurement accuracy<br>• Eliminates weight manipulation disputes<br>• Automated waste volume reporting |
| **Device Orchestration** | • Plug-and-play device registration with auto-discovery<br>• Health monitoring with predictive maintenance alerts<br>• Multi-vendor protocol abstraction (ZKTeco, Hikvision, Avery, Utilcell)<br>• Event replay and reconciliation for network failures | • 95% reduction in device configuration time<br>• Proactive maintenance reduces downtime by 70%<br>• Vendor-agnostic infrastructure |
| **Financial Operations** | • Per-site pricing rule configuration<br>• Real-time fee calculation upon trip completion<br>• Automated invoice generation and delivery<br>• Contract billing consolidation (daily/weekly/monthly) | • Eliminates billing errors and disputes<br>• Accelerates payment cycles by 50%<br>• Provides financial transparency |
| **Compliance & Reporting** | • 5-year trip and weight data retention<br>• Government reporting integration (SAP, custom formats)<br>• Audit trail for all system operations<br>• ISO-aligned quality management system | • Zero non-compliance incidents<br>• Reduces audit preparation time by 90%<br>• Demonstrates environmental impact for certifications |
| **Analytics & Insights** | • Real-time operational dashboards (throughput, device health, revenue)<br>• Historical trend analysis for capacity planning<br>• Waste diversion metrics by material type and customer<br>• Predictive analytics for equipment utilization | • Data-driven expansion decisions<br>• Optimizes resource allocation<br>• Identifies high-value customer segments |

### System Architecture Highlights

**Cloud Tier (Kubernetes on Azure/AWS/GCP):**

- Microservices architecture with 8 core services (Trip, Device, Vehicle, Contract, User, Payment, Reports, Inventory)
- Horizontal auto-scaling based on load (supports peak 500+ concurrent trips across all sites)
- Event-driven communication via Redis Streams and Temporal.io workflows
- PostgreSQL for transactional data, MongoDB for device events
- Zero-downtime deployments with blue-green strategy

**Edge Tier (On-Premises IPC/Servers):**

- Ubuntu LTS / RHEL servers with redundant power supplies and RAID storage
- Local PostgreSQL for trip transactions, MongoDB for device event buffering
- Windows Server VM for proprietary vendor middleware (ZKBio CVSecurity)
- Segregated VLANs (Device, Application, Management traffic)
- Offline operation mode with automatic cloud sync upon reconnection

**Device Tier (Physical Equipment):**

- **Per Zone Standard**: LPR Camera + UHF RFID Reader + QR Scanner + Parking Barrier
- **Scale Zones Additional**: Weighbridge Indicator (ZM510/MATRIX II class) via Telnet/M-Bus
- **Communication Protocols**: TCP, HTTP, Serial (RS-485), Modbus, RTSP
- **Network**: Segregated device VLAN with 802.1X authentication and firewall enforcement

**Integration Patterns:**

- RESTful APIs with OpenAPI 3.0 specifications per service
- Webhook-based event ingestion for external systems (Government portals, SAP)
- SDK generation for mobile/web clients (TypeScript, Rust, Python)
- API Gateway with rate limiting, authentication, and request validation

</details>

---

## 1.3 Return on Investment & Key Performance Indicators

SWMS delivers measurable financial and operational returns within 12-18 months of deployment across a 3-site pilot, with compounding benefits at scale.

**Investment Overview:**

| **Cost Category** | **Pilot (3 Sites)** | **Notes** |
|-------------------|---------------------|-----------|
| Hardware (Devices per site × 3) | $180,000 - $240,000 | Scales, LPR, RFID, Barriers |
| Edge Servers (3 sites) | $45,000 - $60,000 | 2U rackmount with redundancy |
| Software Licensing (Year 1) | $120,000 | Cloud infrastructure, vendor SDKs |
| Implementation Services | $200,000 - $300,000 | Architecture, deployment, training |
| **Total Initial Investment** | **$545,000 - $720,000** | 3 sites, 18-month ROI |

**Annual Operating Costs (Post-Deployment):**

- Cloud Infrastructure: $60,000 - $80,000 (scales with usage)
- Software Maintenance: $24,000 (20% of licensing)
- Edge Server Operations: $15,000 (power, backups, patches)
- **Total Annual OpEx**: $99,000 - $119,000

<details>
<summary><b>:material-clipboard-text: ROI Analysis & KPIs Deep Dive (Click to Expand)</b></summary>

### Financial Returns

**Cost Savings (Per Site, Annual):**

| **Savings Category** | **Legacy Cost** | **SWMS Cost** | **Annual Savings** |
|---------------------|----------------|---------------|-------------------|
| Manual Gate Operations (3 staff, 3 shifts) | $180,000 | $0 | $180,000 |
| Scale Operators (2 staff × 2 shifts) | $120,000 | $0 | $120,000 |
| Paper Tickets & Admin (supplies, printing, filing) | $25,000 | $2,000 | $23,000 |
| Billing Disputes & Corrections (5% of revenue) | $60,000 | $5,000 | $55,000 |
| Manual Data Entry & Reporting | $40,000 | $0 | $40,000 |
| Equipment Downtime (lost revenue) | $80,000 | $15,000 | $65,000 |
| **Total Savings Per Site** | **$505,000** | **$22,000** | **$483,000** |

**Revenue Enhancements (Per Site, Annual):**

- **Increased Throughput**: 3-4x capacity without headcount → +$300,000 revenue (assumes $15/ton average, 20,000 additional tons)
- **Reduced Entry Time**: <10s vs 5+ minutes → +15% daily trips → +$80,000 revenue
- **24/7 Operations**: Automated scales enable night shifts → +$120,000 revenue
- **Dynamic Pricing**: Data-driven pricing optimization → +$50,000 revenue

**Total Annual Benefit (3 Sites):**

- **Cost Savings**: $1,449,000 (3 × $483,000)
- **Revenue Enhancements**: $1,650,000 (3 × $550,000)
- **Total Benefit**: $3,099,000

**ROI Calculation:**

- Initial Investment: $720,000 (high estimate)
- Year 1 Benefit: $3,099,000
- **Payback Period**: 2.8 months
- **3-Year NPV** (8% discount): $7.2M

### Operational Key Performance Indicators

**Efficiency Metrics:**

| **KPI** | **Baseline** | **SWMS Target** | **Status** |
|---------|--------------|-----------------|------------|
| Average Trip Processing Time | 12-15 minutes | 8-10 minutes | ⬇️ 33% reduction |
| Vehicle Entry Time (Gate) | 5+ minutes | <10 seconds | ⬇️ 97% reduction |
| Weight Measurement Accuracy | 95% (manual errors) | 99.9% | ⬆️ 5% improvement |
| Daily Trip Capacity (per site) | 200 trips | 600-800 trips | ⬆️ 300% increase |
| Scale Utilization Rate | 40-50% | 75-85% | ⬆️ 70% improvement |
| Billing Dispute Rate | 8-12% of invoices | <1% | ⬇️ 90% reduction |
| Data Entry Errors | 5-8% | 0% | ✅ Eliminated |

**Reliability & Uptime:**

| **KPI** | **Target** | **SLA** |
|---------|-----------|---------|
| Device Availability | 99.5% | 99.0% minimum |
| API Response Time (P99) | <500ms | <1s max |
| Trip Initiation Latency | <1s | <2s max |
| Edge-Cloud Sync Latency | <5s | <30s max |
| Data Loss Rate | 0% | 0% (no exceptions) |
| Security Incidents | 0 | 0 (mandatory) |

**Business Impact Metrics:**

| **KPI** | **Baseline** | **SWMS Target** | **Strategic Value** |
|---------|--------------|-----------------|---------------------|
| Customer Satisfaction (NPS) | 35-40 | 70+ | Improved experience |
| Contract Renewals Rate | 65% | 90% | Higher customer retention |
| New Customer Acquisition | 5/month | 15/month | Competitive advantage |
| Waste Diversion Rate | 15-20% | 80-90% | Environmental impact |
| Regulatory Compliance Score | 85% | 100% | Risk mitigation |
| Audit Preparation Time | 80 hours | 4 hours | Operational efficiency |

**Environmental & Sustainability KPIs:**

| **Metric** | **Annual Target (3 Sites)** | **Vision 2030 Alignment** |
|-----------|------------------------------|---------------------------|
| C&D Waste Diverted from Landfills | 250,000+ tons | Circular economy goals |
| Recycled Aggregate Produced | 200,000+ tons | Sustainable construction materials |
| CO₂ Emissions Avoided | 15,000+ tons | Climate action commitments |
| Landfill Space Saved | 125,000 m³ | Resource conservation |

### Scalability Economics

**Per-Site Marginal Costs (Sites 4-10):**

- Hardware: $70,000 (standardized procurement, bulk discounts)
- Edge Server: $15,000 (incremental capacity)
- Implementation: $50,000 (templated deployment)
- **Total**: $135,000 per site

**Economies of Scale:**

- Cloud infrastructure: Flat monthly fee up to 50 sites
- Software licensing: Volume discounts at 10+ sites
- Support contracts: Consolidated multi-site SLA reduces per-site cost by 40%

**Break-Even Analysis:**

- **3-Site Pilot**: Break-even at Month 3
- **10-Site Rollout**: Break-even at Month 2 (per incremental site)
- **50-Site Network**: Break-even at Month 1 (fully optimized operations)

</details>

---

## 1.4 Regulatory Compliance & Data Governance

SWMS is architected to meet stringent regulatory requirements for waste management operations, data protection, and financial transparency in the Kingdom of Saudi Arabia.

**Compliance Framework:**

1. **ISO Quality Management System Alignment**: System audit trails, document control, and process standardization support ISO 9001 certification for facility operations

2. **Data Residency Requirements**: All customer data, trip records, and operational telemetry stored within KSA-based cloud regions or on-premises edge servers

3. **5-Year Data Retention Policy**: Automated archival of all trip transactions, weight measurements, device events, and financial records for regulatory audits and legal proceedings

4. **Role-Based Access Control (RBAC)**: Granular permission system with 6 pre-defined roles (ADMIN, MODERATOR, OPERATOR, CLIENT, REGULATOR, FINANCE) ensures data access is limited to authorized personnel

5. **Encryption Standards**: TLS 1.3 for data in transit, AES-256 for data at rest, secure key management via cloud-native KMS

<details>
<summary><b>:material-clipboard-text: Compliance Requirements Deep Dive (Click to Expand)</b></summary>

### Regulatory Obligations

**Waste Management Regulations (KSA Ministry of Environment):**

- **Manifest System**: Digital trip records serve as electronic waste manifests with vehicle origin, destination, waste type, and weight
- **Diversion Reporting**: Monthly and annual submissions to demonstrate compliance with waste diversion targets (currently 50%, increasing to 70% by 2030)
- **Facility Permitting**: System generates operational reports required for permit renewals (uptime, capacity utilization, incident logs)
- **Traceability**: Full audit trail from waste entry to final disposition (recycling, landfill, hazardous segregation)

**Financial & Tax Compliance:**

- **VAT-Compliant Invoicing**: Automated invoice generation with KSA VAT requirements (15% standard rate, exemptions for specific waste types)
- **Revenue Recognition**: Trip completion timestamps and payment records align with accounting standards
- **Audit Trail**: Immutable ledger of all financial transactions (fees calculated, invoices issued, payments received)
- **Anti-Fraud Controls**: Statistical anomaly detection for weight manipulation, duplicate trips, unauthorized fee waivers

**Data Protection (KSA PDPL - Personal Data Protection Law):**

- **Data Minimization**: System collects only operationally necessary data (vehicle plate, contract info, trip timestamps)
- **Consent Management**: Customer portal includes explicit consent for data processing and retention
- **Right to Access**: Customers can request export of their trip history and vehicle data via self-service portal
- **Right to Deletion**: Automated data deletion workflows for expired contracts (after mandatory retention period)
- **Breach Notification**: Automated alerting to data protection officer for security incidents within 72-hour reporting window

**Access Control & Authentication:**

- **SSO Integration**: Single Sign-On with organizational identity providers (Azure AD, Okta)
- **Multi-Factor Authentication (MFA)**: Mandatory for privileged roles (ADMIN, FINANCE, REGULATOR)
- **Session Management**: 30-minute idle timeout, concurrent session limits, audit logging of all access
- **Credential Security**: No plaintext passwords, bcrypt hashing with salt, API key rotation every 90 days

### Audit & Reporting Capabilities

**Regulatory Report Templates:**

| **Report Type** | **Frequency** | **Recipients** | **Data Included** |
|----------------|---------------|----------------|------------------|
| Waste Diversion Summary | Monthly | Ministry of Environment | Total waste received, recycled volumes by material type, diversion rate % |
| Facility Operations Log | Quarterly | Regulatory Authority | Uptime statistics, device health, incident reports, maintenance records |
| Financial Compliance Report | Annual | Tax Authority | Revenue by site, VAT collected, payment reconciliation |
| Environmental Impact Statement | Annual | Ministry of Environment, Public | CO₂ emissions avoided, landfill space saved, recycled material production |
| Security & Privacy Audit | Annual | Data Protection Office | Access logs, security incidents, data retention compliance |

**Audit Trail Requirements:**

All system operations generate immutable audit records with the following attributes:

- **Timestamp**: ISO 8601 format with timezone, microsecond precision
- **Actor**: User ID or system service performing the action
- **Action**: CREATE, UPDATE, DELETE, ACCESS, EXPORT
- **Resource**: Entity type and ID (e.g., Trip #SWMS-2025-123456)
- **Result**: SUCCESS, FAILURE, PARTIAL
- **IP Address**: Source of the request (anonymized after 90 days for privacy)
- **Changes**: Before/after values for data modifications (excluding sensitive fields)

**Retention Policy:**

- Operational logs: 90 days (hot storage), 5 years (cold archive)
- Trip records: 5 years (regulatory requirement)
- Financial records: 7 years (tax authority requirement)
- Device events: 1 year (operational analytics), 5 years (compressed archive)
- Audit logs: 5 years (legal requirement)

### Government System Integration

**SAP Integration (Ministry of Environment):**

- **Protocol**: Secure HTTPS API with mutual TLS authentication
- **Data Format**: XML manifests per government schema
- **Frequency**: Daily batch submission (11:59 PM), with on-demand capability
- **Reconciliation**: Automated validation of submission acknowledgments, retry logic for failures

**e-Government Portal (YESSER Platform):**

- **Facility Registration**: Automated submission of facility operational status
- **Permit Renewals**: Integration with permit management system for auto-renewal triggers
- **Inspection Scheduling**: API-based coordination with regulatory inspection teams

**National Address System (Wasel):**

- **Facility Geolocation**: Integration with Wasel API for standardized address registration
- **Route Validation**: Optional integration for vehicle route verification (future roadmap)

### Data Sovereignty & Localization

**Cloud Region Requirements:**

- **Primary Region**: Saudi Arabia Central (Azure) or Bahrain/UAE (AWS, pending KSA region)
- **Backup Region**: Secondary in-kingdom data center or adjacent GCC country with data transfer agreements
- **Edge Data**: All on-premises edge servers physically located within facility premises in KSA

**Data Transfer Restrictions:**

- **No Cross-Border Transfers**: Customer data never leaves KSA jurisdiction without explicit consent
- **Vendor SLAs**: Cloud providers contractually prohibited from accessing data for purposes other than infrastructure operations
- **Encryption Keys**: Customer-managed encryption keys (CMEK) stored in KSA-based key management service

**Compliance Certifications (Cloud Provider Requirements):**

- ISO/IEC 27001 (Information Security Management)
- ISO/IEC 27017 (Cloud-Specific Security Controls)
- ISO/IEC 27018 (Personal Data Protection in Cloud)
- SOC 2 Type II (Service Organization Controls)
- CSA STAR Certification (Cloud Security Alliance)

</details>

---

## 1.5 Strategic Alignment & Success Criteria

SWMS directly supports the Kingdom's Vision 2030 strategic objectives in sustainability, economic diversification, and digital transformation.

**Vision 2030 Alignment:**

| **Vision 2030 Pillar** | **SWMS Contribution** | **Success Metric** |
|------------------------|----------------------|-------------------|
| **Environmental Sustainability** | 80-90% C&D waste diversion from landfills | 250,000+ tons diverted annually (3-site pilot) |
| **Circular Economy** | Recycled materials production for construction | 200,000+ tons recycled aggregate produced |
| **Digital Transformation** | Cloud-native, AI-ready infrastructure | 100% digitized operations, zero paper |
| **Economic Diversification** | New revenue streams from waste-to-resource | $2M+ annual revenue from recycled products |
| **Private Sector Growth** | Scalable B2B platform for construction industry | 90% customer retention, 15+ new customers/month |

**Program Success Criteria (18-Month Evaluation):**

✅ **Operational Excellence**: 99.5% system uptime, <1s trip initiation latency
✅ **Financial Performance**: Positive ROI within 3 months of go-live per site
✅ **Customer Satisfaction**: Net Promoter Score (NPS) >70
✅ **Regulatory Compliance**: 100% on-time regulatory submissions, zero violations
✅ **Scalability Proof**: Successful expansion from 3 pilot sites to 10+ sites within 12 months
✅ **Environmental Impact**: 80%+ waste diversion rate across all facilities

---

## 1.6 Next Steps & Document Navigation

This High-Level Design document provides the authoritative technical, architectural, and business reference for SWMS implementation. The document is structured for progressive disclosure:

- **Executive Readers**: Review visible summaries in each section
- **Technical Teams**: Expand collapsible sections for detailed specifications
- **Procurement & Finance**: Refer to hardware specifications (Section 09) and ROI analysis (Section 01.3)
- **Compliance & Legal**: Focus on security and compliance (Section 11) and regulatory requirements (Section 01.4)

**Document Sections:**

| Section | Title | Primary Audience |
|---------|-------|------------------|
| [02](02-system-overview.md) | System Overview | All Stakeholders |
| [03](03-business-requirements.md) | Business Requirements | Product, Business, Compliance |
| [04](04-domain-model.md) | Domain Model | Architects, Developers |
| [05](05-architecture-overview.md) | Architecture Overview | Architects, Infrastructure |
| [06](06-microservices-catalog.md) | Microservices Catalog | Developers, DevOps |
| [07](07-data-architecture.md) | Data Architecture | DBAs, Data Engineers |
| [08](08-integration-architecture.md) | Integration Architecture | Device Teams, Integration |
| [09](09-hardware-specifications.md) | Hardware Specifications | Procurement, Field Ops |
| [10](10-edge-computing-design.md) | Edge Computing Design | Infrastructure, Site IT |
| [11](11-security-compliance.md) | Security & Compliance | Security, Legal, Compliance |
| [12](12-operational-design.md) | Operational Design | Operations, SRE |
| [13](13-deployment-cicd.md) | Deployment & CI/CD | DevOps, Platform Engineering |
| [14](14-api-contracts.md) | API Contracts | API Developers, Partners |
| [15](15-event-streams.md) | Event Streams | Backend, Integration |
| [16](16-reporting-analytics.md) | Reporting & Analytics | Business Intelligence, Management |
| [17](17-future-roadmap.md) | Future Roadmap | Strategy, Product |
| [99](99-glossary.md) | Glossary | All (Reference) |

**For Questions or Clarifications:**

- Technical Architecture: [architecture@swms.example.com]
- Business Requirements: [product@swms.example.com]
- Procurement & Contracts: [procurement@swms.example.com]

---

**Document Version Control:**
This document is maintained in Git repository: `github.com/org/swms-docs`
Latest version always available at: `https://docs.swms.example.com/hld/`

**Change Log:**

| Date | Version | Changes | Author |
|------|---------|---------|--------|
| 2025-11-10 | 0.9 | Initial draft for review | Architecture Team |

---

**END OF SECTION 01: EXECUTIVE SUMMARY**

**Section Status**: ✅ Complete (3 pages, progressive disclosure format)
**Next Section**: [02-system-overview.md](02-system-overview.md) - System Overview (4 pages)
