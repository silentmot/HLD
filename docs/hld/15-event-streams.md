# 15 - Event Streams

## Executive Summary (Always Visible)

[2-3 paragraph overview for executives/regulators]

<details>
<summary><b>📋 Technical Deep Dive (Click to Expand)</b></summary>

## Event Catalog

### Domain Events

#### trip.initiated

#### trip.weight_captured

30s correlation window

#### trip.completed

### Integration Events

#### lpr_read

relay_result: open_barrier

#### weight.stable

Modbus TCP/Serial, polled

#### device.health_changed

#### zkbio.event

API poll, bearer token

## Redis Streams Configuration

## Temporal Workflows

### TripWorkflow

#### Steps

- EntryDetection
- AwaitInboundWeight
- AwaitOutboundWeight
- CompleteTrip

#### Retry

- Exponential backoff
- Max 5
- Jitter

#### Hard SLA

24h timeout

#### Compensation

- emit trip.failed
- freeze billing
- audit

### DevicePollingWorkflow

#### Steps

- Poll
- Validate Stability
- Upsert Health
- Emit Events

#### Circuit Breaker

Open on repeated IO errors

#### Ops Alert on Circuit Open

## Trip State Machine Diagram

### States

INITIATED → WEIGHED_IN → WEIGHED_OUT → COMPLETED

## Event Ordering Guarantees

## Idempotency Patterns

## Dead Letter Queues

</details>
