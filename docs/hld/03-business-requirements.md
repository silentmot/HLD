# 03 - Business Requirements

**Document Version**: 2.0
**Last Updated**: November 10, 2025
**Status**: Draft for Review

---
<!--markdownlint-disable-file-->
## Executive Summary

This document defines the functional and operational requirements for the Smart Waste Management System (SWMS), detailing the business processes, user workflows, pricing models, and acceptance criteria. SWMS automates Construction & Demolition (C&D) waste recycling facility operations through device-driven trip lifecycle management for both **waste disposal** and **material sales (buying)** transactions.

**Key Business Objectives**:

- Automate vehicle trip processing from entry gate through disposal/loading to exit (24-30 seconds total)
- Support three distinct pricing models per site for waste disposal (Gatepass Only, Gatepass + Per-Ton, Completely Free)
- Support per-ton pricing for material sales (buying recycled materials)
- Enable customers to self-register vehicles with automatic activation (or approval for open contracts)
- Provide real-time operational dashboards with trip badge system for visual identification
- Generate detailed trip records with flexible reporting filters (vehicle, contract, scale, date)

---

## 1. Business Process Overview

### 1.1 Core Business Flows

<details>
<summary><b>📋 Primary Business Processes (Click to Expand)</b></summary>

#### Process 1: Contract Creation & Management

**Actors**: ADMIN, MODERATOR, CLIENT

**Contract Types**:

##### **Standard Contract**

- **Owner**: CLIENT (customer company or entity)
- **Purpose**: Register multiple vehicles under single contract
- **Vehicle Limit**: Defined per agreement (e.g., 10, 50, 100 vehicles)
- **Expiry Date**: Has validity period (start date, end date)
- **Statuses**: ACTIVE, INACTIVE, SUSPENDED, EXPIRED
- **Creation**: ADMIN or MODERATOR creates contract for client
- **Management**: Can be modified, suspended, or deleted by ADMIN/MODERATOR

**Example**:

```
Contract: CONT-2025-001
Client: ABC Construction Company
Vehicle Limit: 50 vehicles
Validity: 2025-01-01 to 2025-12-31
Status: ACTIVE
```

##### **Open Contract**

- **Owner**: SYSTEM (not owned by any client or admin)
- **Purpose**: Register individual vehicle owners (not companies)
- **Vehicle Limit**: Unlimited
- **Expiry Date**: NO expiry date (always active)
- **Status**: Always ACTIVE, cannot be deleted
- **Creation**: System-generated, managed by ADMIN only
- **Use Case**: Individual truck owner who doesn't need dedicated contract

**Example**:

```
Contract: OPEN-CONTRACT-SYSTEM
Owner: SYSTEM
Vehicle Limit: Unlimited
Validity: Permanent (no expiry)
Status: Always ACTIVE
Purpose: For individual vehicle owners without company contracts
```

**Open Contract Registration Workflows**:

**Workflow A: Customer Self-Registration (Pending Approval)**

```
Precondition: Customer does NOT have any active standard contract

1. Customer navigates to vehicle registration
2. Customer enters vehicle details (plate, type, UHF tag)
3. Customer selects contract: "Open Contract (System)"
4. System validates plate format: {1-4 digits}-{3 letters}
5. System creates vehicle with status: PENDING APPROVAL
6. System generates QR code (available after approval)
7. System sends notification to ADMIN for approval
8. ADMIN reviews vehicle
9. ADMIN approves → Vehicle status changes to ACTIVE
10. Customer can now use vehicle for trips
```

**Workflow B: Admin Registration (Immediate Active)**

```
Precondition: ADMIN wants to register vehicles under open contract

Option 1: Single Vehicle
1. ADMIN navigates to vehicle registration
2. ADMIN enters vehicle details
3. ADMIN selects "Open Contract (System)"
4. System creates vehicle with status: ACTIVE immediately
5. QR code auto-generated

Option 2: Bulk Upload (CSV)
1. ADMIN uploads CSV file (500-1000 vehicles)
2. CSV columns: plate_number, vehicle_type, uhf_tag (optional)
3. System validates all plates (regex check)
4. System creates all vehicles with status: ACTIVE
5. QR codes auto-generated for all vehicles
6. System provides summary report (successful, failed with errors)
```

**Contract Access Control**:

- **Vehicle access to facility**: Controlled by CONTRACT status, NOT vehicle status
- If contract is EXPIRED or SUSPENDED → Vehicle cannot enter facility
- If contract is ACTIVE → Vehicle can enter (assuming vehicle itself is ACTIVE)

---

#### Process 2: Vehicle Registration

**Actors**: CLIENT, ADMIN

**Trigger**: Customer needs to register vehicle for facility access

**Preconditions**:

- Customer has active standard contract (for standard contract registration)
- OR Customer will register under open contract (requires admin approval)

**Registration Flow (Standard Contract)**:

1. CLIENT logs into customer portal
2. CLIENT navigates to "Register Vehicle"
3. CLIENT enters vehicle details:
   - Plate number (required): Format {1-4 digits}-{3 letters} (e.g., "1234-ABC")
   - Vehicle type (required): Dropdown selection (Truck, Trailer, Pickup, Van, etc.)
   - UHF tag (optional): RFID tag identifier (e.g., "RF123456")
   - Notes (optional): Additional information
4. CLIENT selects contract from dropdown (only active standard contracts shown)
5. CLIENT clicks "Register Vehicle"
6. System validates:
   - Plate number format matches regex: `^[0-9]{1,4}-[A-Z]{3}$`
   - Plate number is unique (not already registered)
   - Selected contract is ACTIVE
   - Contract vehicle quantity limit not exceeded
7. System creates vehicle:
   - Status: **ACTIVE** (immediate activation)
   - Automatically generates unique QR code
   - Links vehicle to contract
   - Records default empty weight based on vehicle type
8. System displays success message with QR code
9. Vehicle immediately available for trip processing

**Registration Flow (Open Contract)**:
*(Same as Workflow A in Process 1)*

- Vehicle created with status: PENDING APPROVAL
- ADMIN must approve before vehicle becomes ACTIVE

**Vehicle Status**:

- **ONLY status**: ACTIVE
- **No other statuses**: No inactive, suspended, or other states
- **If vehicle not needed**: Vehicle is DELETED (not deactivated)
- **Access control**: CONTRACT status determines facility access, not vehicle status

**Success Criteria**:

- ✅ Vehicle registered within 1 minute
- ✅ Plate format validated automatically
- ✅ QR code generated and downloadable immediately (for standard contracts)
- ✅ Vehicle available for trips immediately after registration (standard contracts)

**Exception Handling**:

- ❌ Duplicate plate number → Error: "Vehicle with plate ABC-1234 already registered"
- ❌ Invalid plate format → Error: "Invalid format. Use: 1234-ABC (1-4 digits, dash, 3 letters)"
- ❌ Contract expired → Error: "Cannot register vehicles under expired contract"
- ❌ Vehicle limit exceeded → Error: "Contract allows maximum 10 vehicles. Upgrade contract or delete unused vehicles."

---

#### Process 3: Automated Trip Processing - Waste Disposal

**Actors**: Physical Devices (LPR, Scale, RFID, Barrier), Trip Service, Device Service

**Trigger**: Vehicle arrives at facility to dispose C&D waste

**Stage 1: Main Gate Entry (7-8 seconds)**

1. Vehicle approaches main gate (MEG_1, MEG_2, or MEG_3)
2. LPR camera detects and reads license plate (3-5 seconds)
3. System validates vehicle:
   - Vehicle exists in registry with status ACTIVE
   - Associated contract is ACTIVE (not expired, suspended, or inactive)
   - Vehicle has no existing active trip (status: INITIATED, WEIGHED_IN, WEIGHED_OUT)
4. System creates new trip:
   - Generates unique ticket number (format: "SWMS-2025-XXXXXX")
   - Sets trip type: DISPOSAL
   - Sets trip status: INITIATED
   - Records entry time and entry zone (e.g., MEG_1)
   - Links trip to vehicle and contract
   - Assigns badge color: 🔵 BLUE (ongoing/in-process)
5. System sends barrier open command
6. Barrier opens (~3 seconds), vehicle enters facility

**Stage 2: Entrance Scale (7-9 seconds)**

1. Vehicle drives onto entrance scale (SEN_1, SEN_2, or SEN_3)
   - **No fixed mapping**: Vehicle from MEG_1 can use any entrance scale
2. LPR camera at scale detects vehicle plate
3. System correlates vehicle to existing trip:
   - Searches for trip with matching vehicle ID and status INITIATED
   - Validates trip found and trip type is DISPOSAL
4. System opens TCP tunnel to scale indicator
5. Scale indicator monitors load cells for weight stabilization (5-10 seconds)
6. Scale indicator transmits stable weight value via Telnet/M-Bus/Modbus TCP
7. System captures entry weight (GROSS weight = vehicle + waste):
   - Validates weight > 0
   - Records entry_weight, entry_weight_time, entry_weight_zone
   - Updates trip status: WEIGHED_IN
   - Badge remains 🔵 BLUE (ongoing)
8. Vehicle proceeds to disposal area

**Stage 3: Disposal Operations (Variable Duration)**

1. Vehicle operates independently in disposal area
2. Driver disposes waste at designated location
3. **No system tracking**: SWMS does not monitor disposal zone activities
4. Trip status remains WEIGHED_IN during disposal

**Stage 4: Exit Scale (10-13 seconds)**

1. Vehicle drives onto exit scale (SET_1, SET_2, or SET_3)
   - **No fixed mapping**: Vehicle can use any exit scale
2. LPR camera at scale detects vehicle plate
3. System correlates vehicle to existing trip:
   - Searches for trip with matching vehicle ID and status WEIGHED_IN
   - Validates trip type is DISPOSAL
4. System opens TCP tunnel to scale indicator
5. Scale indicator transmits stable weight value
6. System captures exit weight (TARE weight = empty vehicle):
   - Validates weight > 0
   - Records exit_weight, exit_weight_time, exit_weight_zone
   - Calculates net weight: `net_weight = entry_weight - exit_weight`
   - Validates net_weight > 0 (if negative, **system flags trip automatically**)
   - Updates trip status: WEIGHED_OUT
7. System automatically completes trip:
   - Applies fee calculation based on site pricing model (disposal)
   - Updates trip status: COMPLETED
   - Records completion time
   - Generates invoice with disposal fees
   - Assigns badge color: 🟢 GREEN (completed successfully)
8. System sends barrier open command
9. Vehicle exits facility

**Success Criteria**:

- ✅ Trip progresses: INITIATED → WEIGHED_IN → WEIGHED_OUT → COMPLETED
- ✅ Entry and exit weights captured automatically
- ✅ Net weight calculated correctly (entry - exit)
- ✅ Disposal fees applied according to site pricing model
- ✅ Total processing time: 24-30 seconds

**Exception Handling**:

- ❌ Vehicle not registered → Reject at main gate, barrier closed, error displayed
- ❌ Contract expired → Reject at main gate, notify customer to renew
- ❌ Existing active trip → Reject at main gate, display "Vehicle has active trip"
- ❌ LPR fails to capture plate → **System flags trip automatically** (🟡 YELLOW badge)
- ❌ Weight capture fails → **System flags trip automatically** (🟡 YELLOW badge)
- ❌ Negative net weight → **System flags trip automatically** (🟡 YELLOW badge)
- ❌ QR code used as identifier → **System flags trip instantly** (🟡 YELLOW badge)

---

#### Process 4: Automated Trip Processing - Material Sales (Buying)

**Actors**: CLIENT, Physical Devices, Trip Service, Material Service, Device Service

**Trigger**: Customer places order to buy recycled materials

**Stage 1: Order Placement (Online)**

1. CLIENT logs into customer portal
2. CLIENT navigates to "Inventory" or "Material Marketplace"
3. System displays available materials with stock quantities and prices:

   ```
   Material Type         | Available (tons) | Price (SAR/ton)
   ----------------------------------------------------------
   Crushed Concrete      | 250             | 50
   Recycled Aggregate    | 180             | 80
   Mixed Rubble          | 120             | 30
   Wood Chips            | 40              | 20
   Metal Scrap           | 15              | 150
   ```

4. CLIENT selects material type and quantity
5. CLIENT selects pickup date
6. CLIENT (optional) assigns vehicle for pickup from registered vehicles
7. CLIENT clicks "Place Order"
8. System validates:
   - Requested quantity ≤ available stock
   - Customer has active contract (standard or open)
   - At least one active vehicle registered (if vehicle not assigned, customer can assign later)
9. System creates order:
   - Generates ORDER ID (e.g., "ORD-2025-001234")
   - Generates RECEIPT NUMBER (e.g., "RCP-2025-001234")
   - Reserves inventory quantity
   - Records order details (material, quantity, pickup date, customer, contract)
   - Sets order status: PENDING_PICKUP
10. System sends confirmation email with ORDER ID and RECEIPT NUMBER
11. Dashboard chart "Dispatch versus Received" updates

**Stage 2: Pickup Trip Processing (Same Flow as Disposal)**

**Main Gate Entry (7-8 seconds)**:

1. Vehicle approaches main gate with ORDER ID or RECEIPT NUMBER
2. LPR camera detects plate
3. System validates:
   - Vehicle is ACTIVE and registered
   - Contract is ACTIVE
   - Order exists with status PENDING_PICKUP
   - (Optional) Order is assigned to this vehicle OR order not yet assigned to any vehicle
4. System creates trip:
   - Trip type: MATERIAL_SALES (not DISPOSAL)
   - Trip status: INITIATED
   - Links trip to order, vehicle, contract
   - Assigns badge color: 🟣 PURPLE (material sales trip)
5. Barrier opens, vehicle enters

**Entrance Scale (7-9 seconds)**:

1. Vehicle drives onto entrance scale
2. LPR detects plate
3. System correlates trip (status INITIATED, type MATERIAL_SALES)
4. System captures entry weight: **TARE weight** (empty vehicle before loading)
5. Trip status: WEIGHED_IN
6. Badge remains 🟣 PURPLE

**Loading Area (Variable Duration)**:

1. Vehicle proceeds to loading area (not disposal area)
2. Facility staff loads ordered materials onto vehicle
3. **No system tracking during loading**
4. Trip status remains WEIGHED_IN

**Exit Scale (10-13 seconds)**:

1. Vehicle drives onto exit scale
2. LPR detects plate
3. System correlates trip (status WEIGHED_IN, type MATERIAL_SALES)
4. System captures exit weight: **GROSS weight** (vehicle + materials)
5. System calculates material weight: `material_weight = exit_weight - entry_weight`
6. System validates:
   - material_weight > 0 (if negative or zero, **system flags trip**)
   - material_weight approximately matches ordered quantity (tolerance ±5%)
7. System calculates invoice:

   ```
   Material: Crushed Concrete
   Ordered Quantity: 5 tons
   Actual Weight: 5.2 tons
   Price per Ton: 50 SAR
   Total: 5.2 * 50 = 260 SAR
   ```

8. System completes trip:
   - Trip status: COMPLETED
   - Generates invoice for material purchase (separate from disposal invoices)
   - Updates inventory: Dispatched += material_weight
   - Updates order status: COMPLETED
   - Badge remains 🟣 PURPLE (completed sales trip)
9. Barrier opens, vehicle exits

**Inventory Calculation**:

```
Inventory = Production + Received - Dispatched

Where:
- Production: Materials produced from processing (set by ADMIN, e.g., crushed concrete from crushers)
- Received: Recyclable materials from incoming waste (calculated from disposal trips)
- Dispatched: Materials sold (calculated from sales trips)
```

**Critical Rule**:

- **Inventory CANNOT be manually adjusted**
- Only ADMIN can set production amounts
- Received and Dispatched are automatically calculated by system

**Success Criteria**:

- ✅ Order placed online with ORDER ID + RECEIPT
- ✅ Vehicle processes through same trip flow (entry → entrance scale → loading → exit scale)
- ✅ Material weight calculated: exit_weight - entry_weight
- ✅ Invoice based on actual weight × price per ton
- ✅ Inventory automatically updated (Dispatched += material_weight)
- ✅ Trip badge 🟣 PURPLE distinguishes from disposal trips

---

#### Process 5: Flagged Trip Handling

**Actors**: System (Auto-Flag), ADMIN

**Trigger**: System detects issue during trip processing

**Automatic Flagging Conditions**:

1. ❌ **LPR fails to capture plate number** → Trip flagged instantly
2. ❌ **Weight capture fails** (scale timeout, no stabilization) → Trip flagged instantly
3. ❌ **QR code used as identifier** (instead of LPR/RFID) → Trip flagged instantly
4. ❌ **Negative net weight** (exit_weight > entry_weight for disposal) → Trip flagged instantly
5. ❌ **Weight mismatch** (material sales: actual weight differs significantly from order) → Trip flagged

**Flagged Trip Workflow**:

1. System detects issue during trip processing
2. System automatically sets trip status: FLAGGED
3. System assigns badge color: 🟡 YELLOW (flagged trip)
4. System logs flag reason (e.g., "LPR capture failed at SEN-1", "Negative net weight detected")
5. System sends alert to ADMIN dashboard notification panel
6. Trip appears in "Flagged Trips" queue with details:
   - Trip ID / Ticket Number
   - Vehicle Plate
   - Flag Reason
   - Flag Time
   - Current Status: FLAGGED
   - Available Actions: CANCEL

**ADMIN Override (Cancel Only)**:

**Important**:

- ❌ Flagged trips CANNOT be edited or modified
- ❌ Weights CANNOT be manually entered or corrected
- ✅ ONLY action available: **CANCEL**

1. ADMIN reviews flagged trip details
2. ADMIN verifies flag reason is valid
3. ADMIN clicks "Cancel Trip"
4. System prompts for cancellation reason (required text field)
5. ADMIN enters reason (e.g., "LPR malfunction, vehicle processed manually offline")
6. ADMIN confirms cancellation
7. System updates trip:
   - Trip status: CANCELED
   - Badge color: 🔴 RED (canceled)
   - Records cancellation timestamp, admin user ID, cancellation reason
8. **Trip remains in database permanently** (not deleted)
9. Trip appears in reports/history as "Flagged and Canceled"

**Reporting**:

- Flagged trips appear in operational reports
- Canceled trips appear in audit reports
- Both are filterable in reporting module
- Full audit trail maintained for forensic analysis

**Success Criteria**:

- ✅ System auto-flags trips based on predefined conditions
- ✅ Flagged trips clearly marked with 🟡 YELLOW badge
- ✅ ADMIN notified immediately
- ✅ ADMIN can ONLY cancel (no edit/modify)
- ✅ Canceled trips remain in database with full audit trail

---

#### Process 6: Billing & Invoice Generation

**Actors**: Billing Service, FINANCE, CLIENT

**Trigger**: Trip completed (disposal or material sales)

**Invoice Generation (Automatic)**:

1. Trip completion event triggers billing workflow
2. Billing Service retrieves pricing configuration:
   - **For disposal trips**: Site pricing model (Gatepass Only, Gatepass + Per-Ton, Free)
   - **For material sales trips**: Material price per ton

**Disposal Invoice Calculation**:

```
IF pricing_model == GATEPASS_ONLY:
    fee = gatepass_fee
ELSE IF pricing_model == GATEPASS_PER_TON:
    fee = gatepass_fee + (net_weight_kg / 1000) * per_ton_rate
ELSE IF pricing_model == FREE:
    fee = 0
```

**Material Sales Invoice Calculation**:

```
fee = (material_weight_kg / 1000) * material_price_per_ton
```

3. System creates invoice:
   - Generates invoice number (e.g., "INV-2025-001234")
   - Links to trip, contract, vehicle
   - Records fee amount and pricing breakdown
   - Generates QR code for digital payment (if applicable)
   - Sets invoice status: PENDING

4. System determines payment method (configured per-invoice):
   - **Online payment**: Customer pays via payment gateway
   - **Wallet balance**: Deducted from customer wallet (can go negative)
   - **Cash**: Recorded by OPERATOR, approved by MODERATOR/ADMIN

5. System sends invoice to customer:
   - Email with PDF attachment
   - Available in customer portal for download
   - SMS notification (optional)

**Payment Recording**:

**Method 1: Online Payment**:

- Customer clicks "Pay Now" in portal
- Redirects to payment gateway
- Payment confirmed → Invoice status: PAID
- Wallet balance updated (if applicable)

**Method 2: Wallet Balance**:

- System deducts fee from customer wallet
- Wallet can go **NEGATIVE** (e.g., -500 SAR)
- Invoice status: PAID (from wallet)
- Customer must top up wallet to clear negative balance
- **Admin action**: Can revoke entrance access if wallet stays negative beyond threshold

**Method 3: Cash Payment**:

1. Vehicle pays cash at facility (to cashier or operator)
2. OPERATOR opens trip details in system
3. OPERATOR sees checkbox next to comment section: "Record Cash Payment"
4. OPERATOR checks box → Amount input field appears
5. OPERATOR enters cash amount received
6. OPERATOR clicks "Submit for Approval"
7. System creates cash payment record:
   - Status: PENDING_APPROVAL
   - Amount, trip ID, operator ID, timestamp
8. MODERATOR sees payment in approval queue
9. MODERATOR reviews and approves/rejects
10. If approved → Invoice status: PAID
11. **ADMIN also gets notification** and can approve directly
12. System logs approval (user ID, timestamp)

**Monthly Billing Cycle**:

1. On first day of month, system aggregates all invoices per contract for previous month
2. System generates monthly statement:
   - Contract details
   - List of all trips (disposal and sales separately)
   - Total disposal fees
   - Total material purchase fees
   - Payments received
   - Outstanding balance
3. System sends statement to customer email and customer portal
4. FINANCE can generate consolidated financial reports

**Success Criteria**:

- ✅ Invoice generated within 1 minute of trip completion
- ✅ Accurate fee calculation based on trip type and pricing model
- ✅ Customer can pay via online, wallet, or cash
- ✅ Wallet can go negative (with admin access control)
- ✅ Cash payments require operator entry and moderator/admin approval
- ✅ Monthly statements generated automatically

---

#### Process 7: Customer Report Generation & Submission

**Actors**: CLIENT, MODERATOR, ADMIN

**Trigger**: Customer needs trip records for analysis or audit

**Report Generation (Customer Portal)**:

1. CLIENT logs into customer portal
2. CLIENT navigates to "Reports" section
3. CLIENT selects report type: "Trip Records"
4. CLIENT enters search criteria:
   - **By Vehicle**: Select vehicle from dropdown (own vehicles only)
   - **By Contract**: Automatically uses customer's contract
   - **By Scale**: Select scale zone (ENTRY-SIN-001, EXIT-SIT-001, etc.)
   - **By Date**:
     - Fixed selections: Today, Last 7 days, This month
     - Custom date range: From date, To date
5. CLIENT clicks "Generate Report"
6. System queries database with filters
7. System displays report with columns:
   - Trip ID / Ticket Number
   - Vehicle Plate Number
   - Trip Type (Disposal or Material Sales)
   - Entry Time
   - Exit Time
   - Entry Weight (kg)
   - Exit Weight (kg)
   - Net Weight (kg) or Material Weight (kg)
   - Fees (SAR)
   - Badge Status (🟢🟡🔵🔴🟣)
8. CLIENT can:
   - **View** in browser (paginated, 50 records per page)
   - **Print** report
   - **Export** to Excel (.xlsx) or PDF
   - **Submit for Review** (see below)

**Report Submission for Review**:

1. CLIENT clicks "Submit for Review" button on generated report
2. System prompts for submission reason (optional text field)
   - Example reasons: "Dispute resolution", "Audit request", "Invoice discrepancy"
3. CLIENT enters reason (optional) and clicks "Confirm Submission"
4. System creates report submission record:
   - Report ID, customer ID, contract ID
   - Search criteria used
   - Submission timestamp
   - Submission reason
   - Status: PENDING_REVIEW
5. System sends notification:
   - MODERATOR: Submission appears in "Report Review Queue"
   - ADMIN: Notification in dashboard

**Report Review (MODERATOR/ADMIN)**:

1. MODERATOR/ADMIN navigates to "Report Review Queue"
2. System displays list of submitted reports:
   - Report ID
   - Customer Name
   - Contract
   - Submission Date
   - Reason
   - Status
3. MODERATOR/ADMIN selects report to review
4. System displays full report with original search criteria
5. MODERATOR/ADMIN reviews data
6. MODERATOR/ADMIN can:
   - **Add Comment**: Provide feedback or explanation to customer
   - **Approve**: Mark report as reviewed and approved
   - **Request Clarification**: Ask customer for more details
7. MODERATOR/ADMIN submits review
8. System updates report status: REVIEWED
9. System sends notification to customer with review outcome

**Success Criteria**:

- ✅ Customer can generate reports with flexible filters
- ✅ Fixed date selections: Today, Last 7 days, This month
- ✅ Custom date range supported
- ✅ Export to Excel and PDF
- ✅ Customer can submit report for review with reason
- ✅ MODERATOR/ADMIN can review and approve with comments
- ✅ Full audit trail of submission and review

</details>

---

## 2. Pricing Models

### 2.1 Waste Disposal Pricing (Site-Specific)

SWMS supports three distinct pricing models for waste disposal, configured at the site level.

<details>
<summary><b>💰 Disposal Pricing Models (Click to Expand)</b></summary>

#### Model 1: Gatepass Fee Only

**Description**: Fixed fee per trip regardless of waste weight.

**Configuration**:

- `pricing_model`: GATEPASS_ONLY
- `gatepass_fee`: Fixed amount in SAR

**Fee Calculation**:

```
Total Fee = gatepass_fee
```

**Example**:

```
Site: Al-Riyadh Recycling Facility
Pricing Model: Gatepass Only
Gatepass Fee: 100 SAR

Trip Details:
- Entry Weight: 15,000 kg
- Exit Weight: 12,000 kg
- Net Weight: 3,000 kg (3 tons)

Invoice:
- Gatepass Fee: 100 SAR
- Total: 100 SAR
```

---

#### Model 2: Gatepass + Per-Ton Fee

**Description**: Fixed entry fee plus variable charge based on net waste weight.

**Configuration**:

- `pricing_model`: GATEPASS_PER_TON
- `gatepass_fee`: Fixed amount in SAR
- `per_ton_rate`: Variable rate in SAR per metric ton

**Fee Calculation**:

```
Weight_Based_Fee = (net_weight_kg / 1000) * per_ton_rate
Total_Fee = gatepass_fee + Weight_Based_Fee
```

**Example**:

```
Site: Jeddah Construction Waste Center
Pricing Model: Gatepass + Per-Ton
Gatepass Fee: 50 SAR
Per-Ton Rate: 20 SAR/ton

Trip Details:
- Entry Weight: 18,500 kg
- Exit Weight: 14,200 kg
- Net Weight: 4,300 kg (4.3 tons)

Invoice:
- Gatepass Fee: 50 SAR
- Weight-Based Fee: (4,300 / 1000) * 20 = 86 SAR
- Total: 136 SAR
```

---

#### Model 3: Completely Free

**Description**: No fees charged. Used for government facilities, promotional periods, or testing.

**Configuration**:

- `pricing_model`: FREE

**Fee Calculation**:

```
Total Fee = 0
```

**Example**:

```
Site: Municipality Recycling Hub (Government)
Pricing Model: Free

Trip Details:
- Entry Weight: 12,000 kg
- Exit Weight: 9,500 kg
- Net Weight: 2,500 kg (2.5 tons)

Invoice:
- Gatepass Fee: 0 SAR
- Total: 0 SAR
- Note: Invoice generated for record-keeping
```

</details>

### 2.2 Material Sales Pricing

<details>
<summary><b>🏭 Material Sales (Buying) Pricing (Click to Expand)</b></summary>

**Pricing Structure**: Per-ton rates for each material type

**Configuration**: ADMIN configures price per material type in "Material Pricing" module

**Fee Calculation**:

```
Material_Fee = (material_weight_kg / 1000) * material_price_per_ton
```

**Example Material Pricing Table**:

```
Material Type         | Price (SAR/ton)
---------------------------------------
Crushed Concrete      | 50
Recycled Aggregate    | 80
Mixed Rubble          | 30
Wood Chips            | 20
Metal Scrap           | 150
Gypsum                | 40
Brick Fragments       | 35
```

**Example Invoice**:

```
Order: ORD-2025-001234
Material: Crushed Concrete
Ordered Quantity: 5 tons
Actual Weight: 5.2 tons (measured at exit scale)
Price per Ton: 50 SAR

Invoice:
- Material: Crushed Concrete
- Quantity: 5.2 tons
- Unit Price: 50 SAR/ton
- Total: 5.2 * 50 = 260 SAR
```

**Pricing Management**:

- ADMIN can add new materials with prices
- ADMIN can update prices (effective date required, no backdating)
- Historical prices maintained for audit
- Price changes logged with user ID, timestamp, old/new values

</details>

---

## 3. User Roles & Permissions

### 3.1 Role Definitions

SWMS implements Role-Based Access Control (RBAC) with **6 predefined roles**.

<details>
<summary><b>👥 Detailed Role Specifications (Click to Expand)</b></summary>

#### Role 1: ADMIN (System Administrator)

**Purpose**: Full system access for configuration, troubleshooting, and critical operations

**Permissions**:

- ✅ **User Management**: Create, edit, delete users; assign roles
- ✅ **Site Configuration**: Add sites, define zones, assign devices
- ✅ **Device Management**: Add, edit, delete, configure protocols (ADMIN ONLY)
- ✅ **Pricing Configuration**: Set disposal pricing models, material sales prices (ADMIN ONLY)
- ✅ **Contract Management**: Create, edit, suspend, delete contracts (standard and open)
- ✅ **Open Contract Management**: Register vehicles under open contract (single or bulk CSV)
- ✅ **Vehicle Management**: Approve pending vehicles, force delete
- ✅ **Trip Management**:
  - View all trips across all sites
  - **Cancel flagged trips ONLY** (cannot edit or modify)
  - No access to delete non-flagged trips
- ✅ **Invoice Management**: View all invoices, approve cash payments
- ✅ **Inventory Management**: Set production amounts, record received materials
- ✅ **Reporting**: Generate all reports (operational, financial, audit)
- ✅ **Material Management**: Configure material types, prices, stock
- ✅ **System Settings**: Configure timeouts, thresholds, notifications

**Critical Restrictions**:

- ❌ Cannot manually edit trip weights or details
- ❌ Cannot manually adjust inventory (except production amounts)
- ✅ Can ONLY cancel flagged trips (trips remain in database)

---

#### Role 2: MODERATOR (Facility Manager)

**Purpose**: Operational management of facility activities

**Permissions**:

- ✅ **Contract Management**: Create, edit standard contracts (cannot delete)
- ✅ **Vehicle Management**: Approve pending vehicles (open contract registrations)
- ✅ **Trip Monitoring**: View trips for assigned sites
- ✅ **Invoice Review**: View invoices for assigned sites
- ✅ **Cash Payment Approval**: Review and approve operator-submitted cash payments
- ✅ **Report Review**: Review customer-submitted reports, add comments
- ✅ **Operational Reports**: Generate daily/weekly operational reports
- ✅ **Device Monitoring**: View device status for assigned sites
- ❌ Cannot configure pricing models or devices
- ❌ Cannot cancel trips or access admin functions
- ❌ Cannot delete contracts

---

#### Role 3: OPERATOR (Facility Operator)

**Purpose**: Day-to-day operational monitoring and cash payment recording

**Permissions**:

- ✅ **Dashboard Monitoring**: View real-time operational dashboard for assigned site
- ✅ **Trip Viewing**: View active and completed trips
- ✅ **Trip Comments**: Add comments to trips
- ✅ **Cash Payment Recording**:
  - Open trip details
  - Check "Record Cash Payment" checkbox
  - Enter cash amount received
  - Submit for moderator/admin approval
- ✅ **Reporting**: Generate operational reports for assigned site
- ✅ **Device Status**: View device connectivity for assigned site
- ❌ Cannot approve vehicles or contracts
- ❌ Cannot cancel or modify trips
- ❌ Cannot access financial data beyond cash payment recording
- ❌ Cannot configure anything

---

#### Role 4: CLIENT (Customer)

**Purpose**: Self-service vehicle registration, trip history, invoice access, material ordering

**Permissions**:

- ✅ **Vehicle Management**:
  - Register vehicles (single or bulk) under own contracts
  - View own vehicles
  - Delete own vehicles (ACTIVE vehicles only, no pending approval vehicles)
  - Download QR codes (auto-generated)
- ✅ **Material Orders**:
  - View inventory (materials, quantities, prices)
  - Place orders for materials
  - Assign vehicles to orders
  - View order history
- ✅ **Trip Viewing**: View trip history for own vehicles only
- ✅ **Invoicing**:
  - View own invoices
  - Download invoice PDFs
  - Pay online or via wallet
- ✅ **Reporting**:
  - Generate reports (own vehicles, own contract)
  - Filter by vehicle, scale, date
  - Export to Excel/PDF
  - Print reports
  - Submit reports for review
- ✅ **Wallet Management**: View balance, top up wallet
- ❌ Cannot view other customers' data
- ❌ Cannot modify approved vehicles
- ❌ Cannot access operational dashboards

---

#### Role 5: REGULATOR (Government Official)

**Purpose**: Audit trail access and regulatory reporting

**Permissions**:

- ✅ **Trip Viewing**: View all trips (read-only) across all sites
- ✅ **Audit Reports**: Generate audit trails, trip logs, weight records
- ✅ **Data Export**: CSV/Excel exports for government reporting
- ✅ **Site Information**: View site configurations, pricing models
- ❌ Cannot modify any data
- ❌ Cannot approve vehicles or contracts
- ❌ Cannot access financial data (invoices, payments)

---

#### Role 6: FINANCE (Finance Team)

**Purpose**: Financial management, billing, payment tracking

**Permissions**:

- ✅ **Pricing Configuration**: Set disposal pricing models, material sales prices (shared with ADMIN)
- ✅ **Invoice Management**: View all invoices across all sites and contracts
- ✅ **Payment Recording**:
  - Record online payments
  - Update invoice status
  - Approve cash payments (shared with ADMIN/MODERATOR)
- ✅ **Financial Reports**: Revenue by site, payment aging, monthly statements, profit/loss
- ✅ **Wallet Management**: View customer wallet balances, approve top-ups
- ✅ **Manual Fee Override**: Adjust invoice amounts with approval workflow and reason code (requires ADMIN approval for amounts >threshold)
- ✅ **Export Financial Data**: For accounting system integration (SAP, etc.)
- ❌ Cannot modify trips or vehicle registrations
- ❌ Cannot access operational dashboards or device status

</details>

### 3.2 Permission Matrix

<details>
<summary><b>📊 Comprehensive RBAC Matrix (Click to Expand)</b></summary>

| Permission | ADMIN | MODERATOR | OPERATOR | CLIENT | REGULATOR | FINANCE |
|------------|-------|-----------|----------|--------|-----------|---------|
| **User & Role Management** |
| Create/edit/delete users | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Assign roles | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Site & Device Configuration** |
| Configure sites | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Configure devices | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View device status | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| **Contract Management** |
| Create standard contracts | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Edit standard contracts | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Delete contracts | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| Suspend/reactivate contracts | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Manage open contracts | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Vehicle Management** |
| Register vehicles | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| Approve pending vehicles | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Bulk upload (CSV) | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| View own vehicles | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| Delete own vehicles | ✅ | ✅ | ❌ | ✅ | ❌ | ❌ |
| Force delete any vehicle | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Trip Management** |
| View all trips | ✅ | ✅ (own sites) | ✅ (own site) | ✅ (own) | ✅ | ❌ |
| View trip details | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| Add trip comments | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Cancel flagged trips | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Material Management** |
| View inventory | ✅ | ✅ | ✅ | ✅ | ❌ | ✅ |
| Place material orders | ✅ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Configure material prices | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Set production amounts | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Financial Management** |
| Configure pricing models | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| View all invoices | ✅ | ✅ (own sites) | ❌ | ✅ (own) | ❌ | ✅ |
| Record cash payments | ✅ | ✅ | ✅ | ❌ | ❌ | ❌ |
| Approve cash payments | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| Manual fee override | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| View wallet balances | ✅ | ❌ | ❌ | ✅ (own) | ❌ | ✅ |
| Revoke entrance access | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Reporting** |
| Generate operational reports | ✅ | ✅ | ✅ | ✅ (own) | ✅ | ❌ |
| Generate financial reports | ✅ | ❌ | ❌ | ❌ | ❌ | ✅ |
| Generate audit reports | ✅ | ❌ | ❌ | ❌ | ✅ | ❌ |
| Submit reports for review | ❌ | ❌ | ❌ | ✅ | ❌ | ❌ |
| Review submitted reports | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| Export data (Excel/PDF/CSV) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

</details>

---

## 4. Trip Badge System

### 4.1 Visual Identification

SWMS uses a color-coded badge system to visually identify trip types and statuses in real-time dashboards and reports.

<details>
<summary><b>🎨 Badge Color Specifications (Click to Expand)</b></summary>

| Badge Color | Meaning | When Applied | Trip Status |
|-------------|---------|--------------|-------------|
| 🟢 **GREEN** | Completed trip (success) | Trip reaches COMPLETED status without issues | COMPLETED |
| 🟡 **YELLOW** | Flagged trip (system detected issue) | System auto-flags during processing | FLAGGED |
| 🔵 **BLUE** | Ongoing/in-process trip | Trip in active states | INITIATED, WEIGHED_IN, WEIGHED_OUT |
| 🔴 **RED** | Canceled trip (admin canceled flagged trip) | Admin cancels flagged trip | CANCELED |
| 🟣 **PURPLE** | Material sales trip (buying, not disposal) | Trip type is MATERIAL_SALES | INITIATED, WEIGHED_IN, WEIGHED_OUT, COMPLETED |

**Badge Application Rules**:

1. **Green (Completed - Success)**:
   - Applied when trip reaches COMPLETED status
   - No flags or issues detected
   - Normal completion of disposal or sales trip

2. **Yellow (Flagged)**:
   - Applied instantly when system detects:
     - LPR capture failure
     - Weight capture failure
     - QR code used as identifier
     - Negative net weight
     - Significant weight mismatch (sales orders)
   - Persists until admin cancels trip

3. **Blue (Ongoing)**:
   - Applied during active trip processing
   - Statuses: INITIATED (at main gate), WEIGHED_IN (after entrance scale), WEIGHED_OUT (after exit scale)
   - Changes to Green or Purple when completed

4. **Red (Canceled)**:
   - Applied only when admin cancels flagged trip
   - Trip permanently marked as canceled
   - Remains in database for audit

5. **Purple (Material Sales)**:
   - Applied for MATERIAL_SALES trip type
   - Distinguishes buying trips from disposal trips
   - Visible throughout entire trip lifecycle
   - Remains purple even when completed

**Dashboard Display**:

```
Real-Time Trip Monitor

┌──────────────────────────────────────────────────────────┐
│ Trip ID        | Plate    | Status      | Badge          │
├──────────────────────────────────────────────────────────┤
│ SWMS-2025-001  | 1234-ABC | INITIATED   | 🔵 Ongoing     │
│ SWMS-2025-002  | 5678-XYZ | COMPLETED   | 🟢 Success     │
│ SWMS-2025-003  | 9012-DEF | FLAGGED     | 🟡 Flagged     │
│ SWMS-2025-004  | 3456-GHI | WEIGHED_IN  | 🟣 Sales       │
│ SWMS-2025-005  | 7890-JKL | CANCELED    | 🔴 Canceled    │
└──────────────────────────────────────────────────────────┘
```

</details>

---

## 5. Acceptance Criteria

### 5.1 Feature Acceptance Scenarios

<details>
<summary><b>✅ Gherkin Test Scenarios (Click to Expand)</b></summary>

#### Feature: Vehicle Registration - Standard Contract

**Scenario 1: Successful vehicle registration with auto-activation**

```gherkin
GIVEN customer has active standard contract with vehicle limit 10
AND currently registered vehicles: 5
WHEN customer submits vehicle with plate "1234-ABC"
AND vehicle type "Truck"
THEN system validates plate format: {1-4 digits}-{3 letters}
AND system creates vehicle with status ACTIVE
AND system generates unique QR code
AND system displays success message
AND vehicle available for trips immediately
```

**Scenario 2: Duplicate plate rejection**

```gherkin
GIVEN vehicle with plate "1234-ABC" exists with status ACTIVE
WHEN customer attempts to register new vehicle with plate "1234-ABC"
THEN system rejects registration
AND displays error "Vehicle with plate 1234-ABC already registered"
AND vehicle record not created
```

**Scenario 3: Invalid plate format**

```gherkin
GIVEN customer enters plate "ABC1234" (invalid format)
WHEN customer submits registration
THEN system rejects with error "Invalid format. Use: 1234-ABC (1-4 digits, dash, 3 letters)"
AND vehicle not created
```

---

#### Feature: Vehicle Registration - Open Contract

**Scenario 1: Customer self-registration (pending approval)**

```gherkin
GIVEN customer does NOT have active standard contract
WHEN customer registers vehicle with plate "1234-ABC"
AND selects "Open Contract (System)"
THEN system validates plate format
AND creates vehicle with status PENDING_APPROVAL
AND generates QR code (visible after approval)
AND sends notification to ADMIN
AND displays message "Vehicle submitted for approval"
```

**Scenario 2: Admin bulk upload (immediate activation)**

```gherkin
GIVEN admin uploads CSV with 500 vehicles
AND all plates match format {1-4 digits}-{3 letters}
WHEN admin selects "Open Contract (System)"
AND clicks "Upload"
THEN system creates 500 vehicles with status ACTIVE
AND generates QR codes for all vehicles
AND displays summary "500 vehicles registered successfully"
```

---

#### Feature: Automated Trip - Waste Disposal

**Scenario 1: Normal disposal trip flow**

```gherkin
GIVEN vehicle "1234-ABC" is ACTIVE
AND contract is ACTIVE
AND no existing active trip
WHEN vehicle detected at main gate MEG_1
THEN system creates trip with type DISPOSAL, status INITIATED, badge 🔵 BLUE

WHEN vehicle detected at entrance scale SEN_2
AND system captures entry weight 15,000 kg
THEN system updates trip status WEIGHED_IN
AND badge remains 🔵 BLUE

WHEN vehicle detected at exit scale SET_3
AND system captures exit weight 12,000 kg
THEN system calculates net_weight = 15,000 - 12,000 = 3,000 kg
AND applies disposal fees based on site pricing
AND updates trip status COMPLETED
AND badge changes to 🟢 GREEN
AND generates invoice
```

**Scenario 2: LPR capture failure - auto-flag**

```gherkin
GIVEN vehicle on entrance scale SEN_1
AND LPR camera fails to read plate
WHEN system detects LPR failure
THEN system automatically sets trip status FLAGGED
AND badge changes to 🟡 YELLOW
AND logs flag reason "LPR capture failed at SEN-1"
AND sends alert to ADMIN
```

**Scenario 3: Negative net weight - auto-flag**

```gherkin
GIVEN trip with entry_weight 12,000 kg
AND exit_weight 15,000 kg (vehicle heavier on exit)
WHEN system calculates net_weight = 12,000 - 15,000 = -3,000 kg
THEN system automatically flags trip
AND badge changes to 🟡 YELLOW
AND logs flag reason "Negative net weight detected"
```

---

#### Feature: Material Sales (Buying)

**Scenario 1: Customer orders material online**

```gherkin
GIVEN customer views inventory
AND Crushed Concrete available: 250 tons, price 50 SAR/ton
WHEN customer places order:
  - Material: Crushed Concrete
  - Quantity: 5 tons
  - Pickup date: 2025-12-15
  - Vehicle: 1234-ABC (optional)
THEN system validates quantity <= available stock
AND creates order with ORDER ID and RECEIPT NUMBER
AND reserves 5 tons inventory
AND sends confirmation email
```

**Scenario 2: Buyer vehicle trip flow**

```gherkin
GIVEN order ORD-2025-001 for 5 tons Crushed Concrete
AND vehicle "1234-ABC" assigned to order
WHEN vehicle detected at main gate
THEN system creates trip with type MATERIAL_SALES, badge 🟣 PURPLE

WHEN vehicle on entrance scale, captures entry_weight 8,000 kg (TARE)
AND updates status WEIGHED_IN

WHEN vehicle loaded at loading area (no system tracking)

WHEN vehicle on exit scale, captures exit_weight 13,200 kg (GROSS)
THEN system calculates material_weight = 13,200 - 8,000 = 5,200 kg (5.2 tons)
AND calculates invoice: 5.2 * 50 = 260 SAR
AND updates trip status COMPLETED, badge remains 🟣 PURPLE
AND updates inventory: Dispatched += 5.2 tons
```

---

#### Feature: Flagged Trip Handling

**Scenario 1: Admin cancels flagged trip**

```gherkin
GIVEN trip SWMS-2025-003 with status FLAGGED, badge 🟡 YELLOW
AND flag reason "Weight capture failed at SEN-1"
WHEN ADMIN reviews flagged trip
AND ADMIN clicks "Cancel Trip"
AND enters cancellation reason "Scale malfunction, processed offline"
AND confirms cancellation
THEN system updates trip status CANCELED
AND badge changes to 🔴 RED
AND records admin ID, timestamp, cancellation reason
AND trip remains in database (not deleted)
```

**Scenario 2: Attempt to edit flagged trip (should fail)**

```gherkin
GIVEN trip with status FLAGGED
WHEN ADMIN attempts to edit trip weights manually
THEN system displays error "Flagged trips cannot be edited"
AND shows only "Cancel Trip" button
```

---

#### Feature: Cash Payment Recording

**Scenario 1: Operator records cash payment**

```gherkin
GIVEN trip SWMS-2025-005 completed with invoice 136 SAR
WHEN OPERATOR opens trip details
AND checks "Record Cash Payment" checkbox
AND enters amount 136 SAR
AND clicks "Submit for Approval"
THEN system creates payment record with status PENDING_APPROVAL
AND sends notification to MODERATOR

WHEN MODERATOR reviews payment
AND approves payment
THEN invoice status updates to PAID
AND system logs approval (moderator ID, timestamp)
AND ADMIN receives notification
```

---

#### Feature: Customer Report Submission

**Scenario 1: Customer generates and submits report**

```gherkin
GIVEN customer has 20 trips in last 7 days
WHEN customer selects "Last 7 days" date filter
AND clicks "Generate Report"
THEN system displays 20 trips with details

WHEN customer clicks "Submit for Review"
AND enters reason "Request audit for invoice discrepancy"
AND confirms submission
THEN system creates report submission with status PENDING_REVIEW
AND sends notification to MODERATOR and ADMIN

WHEN MODERATOR reviews submission
AND adds comment "Reviewed - all invoices correct"
AND approves report
THEN system updates status REVIEWED
AND sends notification to customer
```

</details>

---

## 6. Functional Requirements Traceability

### 6.1 Business Requirements Mapping

<details>
<summary><b>🔗 Traceability Matrix (Click to Expand)</b></summary>

| Requirement ID | Business Requirement | System Feature | Module | Verified By | Priority |
|----------------|---------------------|----------------|--------|-------------|----------|
| **BR-001** | Customers register vehicles under active standard contracts | Vehicle registration form with auto-activation | Vehicle Management | UC-01 | P0 |
| **BR-002** | Each vehicle receives auto-generated unique QR code | QR code generation upon vehicle creation | Vehicle Management | UC-01 | P0 |
| **BR-003** | Open contract vehicles require admin approval | Pending approval status, admin approval interface | Vehicle Management | UC-02 | P0 |
| **BR-004** | Admin bulk upload vehicles to open contract (CSV 500-1000) | CSV import with validation, batch creation | Vehicle Management | UC-02 | P0 |
| **BR-005** | Support three disposal pricing models per site | Pricing configuration with site-level settings | Financial Operations | Process 6 | P0 |
| **BR-006** | Support per-ton pricing for material sales | Material price configuration, sales invoice calculation | Financial Operations, Inventory | Process 4 | P0 |
| **BR-007** | Trip auto-initiates upon vehicle detection at main gate | LPR integration, trip creation workflow | Trip Management, Device Orchestration | Process 3 | P0 |
| **BR-008** | Entry weight captured automatically at entrance scale | Scale TCP tunnel, weight capture service | Trip Management, Device Orchestration | Process 3 | P0 |
| **BR-009** | Exit weight captured automatically at exit scale | Scale TCP tunnel, weight capture service | Trip Management, Device Orchestration | Process 3 | P0 |
| **BR-010** | Net weight = entry_weight - exit_weight (disposal) | Net weight calculation in trip completion | Trip Management | Process 3 | P0 |
| **BR-011** | Material weight = exit_weight - entry_weight (sales) | Material weight calculation in sales completion | Trip Management | Process 4 | P0 |
| **BR-012** | Disposal fees calculated per site pricing model | Fee calculation service with pricing lookup | Financial Operations | Process 6 | P0 |
| **BR-013** | Material sales fees calculated per-ton | Material invoice calculation | Financial Operations | Process 4 | P0 |
| **BR-014** | Invoice generated automatically upon trip completion | Invoice generation service, PDF export | Financial Operations | Process 6 | P0 |
| **BR-015** | Vehicles from any gate can use any scale (no fixed mapping) | Trip correlation by vehicle ID, not zone sequence | Trip Management | Process 3, Process 4 | P0 |
| **BR-016** | System prevents duplicate active trips for same vehicle | Validation: no existing trip INITIATED/WEIGHED_IN/WEIGHED_OUT | Trip Management | Process 3 | P0 |
| **BR-017** | Contract status controls facility access (not vehicle status) | Real-time contract validation at main gate | Trip Management, Contract Management | Process 3 | P0 |
| **BR-018** | Vehicle status is ONLY "ACTIVE" (no other statuses) | Vehicle model with single status field | Vehicle Management | Process 2 | P0 |
| **BR-019** | System auto-flags trips on LPR/weight failure or QR usage | Auto-flagging rules in trip service | Trip Management | Process 5 | P0 |
| **BR-020** | Admin can ONLY cancel flagged trips (no edit/modify) | Flagged trip cancel workflow, no edit UI | Trip Management | Process 5 | P0 |
| **BR-021** | Canceled trips remain in database with audit trail | Soft delete with CANCELED status, full logging | Trip Management | Process 5 | P0 |
| **BR-022** | Trip badge system (5 colors) for visual identification | Badge assignment logic based on status/type | Trip Management | Process 3-5 | P0 |
| **BR-023** | Inventory = Production + Received - Dispatched | Inventory calculation formula, cannot be manually adjusted | Inventory Management | Process 4 | P0 |
| **BR-024** | Admin sets production amounts, system calculates rest | Production amount configuration, auto-calculation | Inventory Management | Process 4 | P0 |
| **BR-025** | Customers view inventory and place orders online | Inventory display, order placement form | Inventory Management | Process 4 | P0 |
| **BR-026** | Payment methods: Online, Wallet (can be negative), Cash | Payment configuration per-invoice | Financial Operations | Process 6 | P0 |
| **BR-027** | Operator records cash, Moderator/Admin approves | Cash payment workflow with approval | Financial Operations | Process 6 | P0 |
| **BR-028** | Admin revokes entrance access if wallet negative beyond threshold | Access control based on wallet balance | Financial Operations, Trip Management | Process 6 | P0 |
| **BR-029** | Reports searchable by vehicle, contract, scale, date | Advanced search with multiple filters | Reporting Module | Process 7 | P0 |
| **BR-030** | Fixed date selections: Today, Last 7 days, This month | Predefined date filters in reporting | Reporting Module | Process 7 | P0 |
| **BR-031** | Customers submit reports for review to Moderator/Admin | Report submission workflow with approval | Reporting Module | Process 7 | P1 |
| **BR-032** | Admin configures pricing models (disposal and sales) | Pricing configuration interface | Financial Operations | Admin only | P0 |
| **BR-033** | Admin configures devices and assigns to zones | Device configuration with zone mapping | Device Orchestration | Admin only | P0 |
| **BR-034** | RBAC with 6 predefined roles (no Supervisor, no Contract Manager) | RBAC implementation with permission matrix | User Management | Section 3 | P0 |
| **BR-035** | Dashboard shows "Dispatch versus Received" chart | Analytics chart for material flow | Inventory Management | Process 4 | P1 |

</details>

---

## Document Control

**Version History**:

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | 2025-11-10 | SWMS Architecture Team | Initial draft (incorrect assumptions) |
| 2.0 | 2025-11-10 | SWMS Architecture Team | Complete rewrite: Added material sales, open contracts, trip badges, flagged trips, corrected RBAC, accurate payment workflows, customer report submission |
