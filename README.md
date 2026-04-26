# AI Local Toolkit

A self-hosted AI toolkit running locally via Docker Compose, bundling an LLM gateway, workflow automation, and a chat UI — all backed by a shared PostgreSQL database.

All free [Ollama Cloud](https://ollama.com) models are pre-configured out of the box. Just create an Ollama account, generate an API key, and you're ready to go. Additional models and providers can be added later through LiteLLM.

> **⚠️ Warning:** This project is intended for **local development and experimentation only**. It does not implement any security hardening (no TLS, no authentication proxy, default credentials, etc.). If you choose to deploy it in a production environment, you do so entirely at your own risk.

## Services

| Service        | Description                         | URL                      |
| -------------- | ----------------------------------- | ------------------------ |
| **LiteLLM**    | LLM proxy / API gateway             | http://localhost:4000    |
| **LiteLLM UI** | Admin dashboard                     | http://localhost:4000/ui |
| **n8n**        | Workflow automation                  | http://localhost:5678    |
| **Open WebUI** | Chat interface for LLMs             | http://localhost:3000    |
| **PostgreSQL** | Shared database (LiteLLM + n8n)     | `localhost:5432`         |

## Architecture

```
                    ┌─────────────┐
                    │  Open WebUI │ :3000
                    └──────┬──────┘
                           │ OpenAI-compatible API
                    ┌──────▼──────┐
                    │   LiteLLM   │ :4000
                    └──────┬──────┘
                    │      │
          ┌─────────┘      └──────────────────┐
          │ Ollama Cloud                       │ PostgreSQL
          │ (35+ models)               ┌───────▼───────┐
                                       │   PostgreSQL  │ :5432
                                       └───────┬───────┘
                                               │
                                        ┌──────▼──────┐
                                        │     n8n     │ :5678
                                        └─────────────┘
```

All containers communicate over the shared `ai-toolkit` Docker network using internal hostnames (`postgres`, `litellm`, `n8n`, `openwebui`).

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
- An [Ollama Cloud](https://ollama.com) account and API key
- **Recommended:** 8 GB RAM minimum; 16 GB for running multiple large models simultaneously

Create the shared Docker network (one-time):
```bash
docker network create ai-toolkit
```

## Quick Start

1. **Clone the repository**

2. **Create your `.env` file**
   ```bash
   cp .env.dist .env
   ```
   Edit `.env` and fill in the required values:
   ```dotenv
   # Postgres
   POSTGRES_DB=postgres
   POSTGRES_USER=postgres
   POSTGRES_PASSWORD=<your_secure_password>

   # LiteLLM
   LITELLM_MASTER_KEY=sk-<generate_a_key>
   LITELLM_SALT_KEY=sk-<generate_a_key>
   OLLAMA_API_KEY=<your_ollama_api_key>

   # General
   TZ=<YOUR_TIMEZONE>   # e.g. America/New_York, Europe/Paris
   ```

3. **Configure LiteLLM models** *(optional)*

   Edit `config/litellm_config.yaml` to add or modify models. The ~35 Ollama Cloud models are pre-configured.

4. **Start the stack**
   ```bash
   docker compose up -d
   ```

5. **Verify all services are healthy**
   ```bash
   docker compose ps
   ```
   Wait until all services show `healthy` before using them. Open WebUI auto-connects to LiteLLM on startup.

## Project Structure

```
.
├── .env                          # Environment variables (git-ignored)
├── .env.dist                     # Environment variables template
├── docker-compose.yml            # Service definitions
├── config/
│   ├── init_db.sh                # Creates n8n & litellm databases on first run
│   └── litellm_config.yaml       # LiteLLM model configuration
└── README.md
```

## Configuration

### LiteLLM

LiteLLM acts as a unified API gateway to multiple LLM providers. Models are configured in `config/litellm_config.yaml`. The admin UI is available at http://localhost:4000/ui.

Authentication uses the `LITELLM_MASTER_KEY` defined in your `.env` file. Use the same key as a Bearer token when calling the API directly:
```bash
curl http://localhost:4000/v1/models \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY"
```

To add a new Ollama Cloud model, append to `config/litellm_config.yaml`:
```yaml
- model_name: my-model
  litellm_params:
    model: ollama_chat/<model-id>
    api_base: https://ollama.com
    api_key: os.environ/OLLAMA_API_KEY
```
Then restart LiteLLM: `docker compose restart litellm`

### n8n

n8n provides workflow automation with a visual editor at http://localhost:5678. It uses PostgreSQL for persistent storage.

### Open WebUI

Open WebUI is pre-configured to connect to LiteLLM at http://localhost:3000. No manual setup is needed — models appear automatically once LiteLLM is healthy.

### PostgreSQL

A single PostgreSQL 16 instance shared by LiteLLM and n8n. The `config/init_db.sh` script automatically creates the `n8n` and `litellm` databases on first initialization.

> **Note:** The init script only runs when the `postgres-data` volume is created for the first time. To re-run it:
> ```bash
> docker compose down
> docker volume rm toolkit_postgres-data
> docker compose up -d
> ```

## Useful Commands

```bash
# Start all services
docker compose up -d

# Stop all services
docker compose down

# View logs (all services)
docker compose logs -f

# View logs for a specific service
docker compose logs -f litellm

# Restart a single service after config change
docker compose restart litellm

# Reset everything (removes all data)
docker compose down -v && docker compose up -d
```

## Troubleshooting

**`docker compose up` fails with "network ai-toolkit not found"**
The external network must be created before starting the stack:
```bash
docker network create ai-toolkit
```

**Services show as `starting` or `unhealthy` for a long time**
LiteLLM and n8n wait for Postgres to be healthy before starting. On first run, Postgres initializes its databases which can take 20–30 seconds. Check progress with:
```bash
docker compose logs -f postgres
```

**Open WebUI shows no models**
Check that LiteLLM is healthy: `docker compose ps`. If it's running but shows no models, verify your `OLLAMA_API_KEY` in `.env` and check LiteLLM logs:
```bash
docker compose logs -f litellm
```

**n8n can't connect to the database**
Ensure `POSTGRES_USER` and `POSTGRES_PASSWORD` in `.env` match what was used when the `postgres-data` volume was first created. If they differ, either reset the volume or revert the credentials.

**Port already in use**
Another process is using port 4000, 5678, or 3000. Find and stop it, or change the host-side port in `docker-compose.yml` (e.g. `"4001:4000"`).
