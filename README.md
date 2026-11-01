# Qi v2 Services

Infrastructure services for the Qi v2 trading platform.

## Services

- **Database**: TimescaleDB configurations
- **Streaming**: RedPanda (Kafka-compatible) setup
- **Docker Compose**: Complete service orchestration

## Quick Start

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Stop services
docker compose down
```

## Database Services

- **TimescaleDB**: Time-series database for market data storage

## Streaming Services

- **RedPanda**: Kafka-compatible streaming platform with topic and schema configurations