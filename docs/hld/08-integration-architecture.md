# 08 - Integration Architecture

## Executive Summary (Always Visible)

[2-3 paragraph overview for executives/regulators]

<details>
<summary><b>📋 Technical Deep Dive (Click to Expand)</b></summary>

## Integration Landscape Diagram

## Device Protocols

### Weighbridge Indicators

- Telnet
- M-Bus
- Modbus TCP
- Serial

### LPR Cameras

- RTSP
- HTTP API

### UHF RFID

- Serial
- TCP

### QR Scanners

- USB
- Serial

### Barrier Gates

- Relay
- TCP

### ZKBio CVSecurity

- HTTP API
- Polling

## Device Integration Sequence

[FULL SEQUENCE DIAGRAM FROM USER - NO SIMPLIFICATION]

## Channel-to-Zone Mapping Table

### "MGE-1" → MEG_1 (MAIN_GATE)

### "SEN-1" → SEN_1 (INBOUND_SCALE)

### "SIT-1" → SIT_1 (OUTBOUND_SCALE)

## API Contracts

### POST /trips/initiate

### POST /events/weight

### POST /trips/complete

### GET /vehicles/{plate}

### GET /devices/{id}/health

### POST /devices/events

## Vendor SDK Integration

## Government/SAP Endpoints

## Webhook Patterns

## Error Handling & Retries

</details>
