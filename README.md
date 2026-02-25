# AI Local Toolkit

A self-hosted AI toolkit running locally via Docker Compose, bundling an LLM gateway, workflow automation, and a chat UI — all backed by a shared PostgreSQL database.

All free [Ollama Cloud](https://ollama.com) models are pre-configured out of the box. Just create an Ollama account, generate an API key, and you're ready to go. Additional models and providers can be added later through LiteLLM.

> **⚠️ Warning:** This project is intended for **local development and experimentation only**. It does not implement any security hardening (no TLS, no authentication proxy, default credentials, etc.). If you choose to deploy it in a production environment, you do so entirely at your own risk.

## Services

| Service      | Description                          | URL                          |
| ------------ | ------------------------------------ | ---------------------------- |
| **LiteLLM**  | LLM proxy / API gateway             | http://localhost:4000        |
| **n8n**      | Workflow automation                  | http://localhost:5678        |
| **Open WebUI** | Chat interface for LLMs           | http://localhost:3000        |
| **PostgreSQL** | Shared database (LiteLLM + n8n)  | `localhost:5432`             |

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) & [Docker Compose](https://docs.docker.com/compose/install/)
- A Docker network named `local` — used so all containers can communicate with each other simply by container name (e.g. `http://litellm:4000`):
  ```bash
  docker network create local
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
   TZ=Africa/Tunis
   ```

3. **Configure LiteLLM models**

   Edit `config/litellm_config.yaml` to add or modify the models available through the proxy.

4. **Start the stack**
   ```bash
   docker compose up -d
   ```

5. **Verify**
   ```bash
   docker compose ps
   ```

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

Authentication uses the `LITELLM_MASTER_KEY` defined in your `.env` file.

### n8n

n8n provides workflow automation with a visual editor at http://localhost:5678. It uses PostgreSQL for persistent storage.

### Open WebUI

Open WebUI provides a ChatGPT-like interface at http://localhost:3000. Connect it to LiteLLM by configuring `http://litellm:4000` as the OpenAI-compatible API endpoint (with your `LITELLM_MASTER_KEY` as the API key).

### PostgreSQL

A single PostgreSQL 16 instance is shared by LiteLLM and n8n. The `config/init_db.sh` script automatically creates the `n8n` and `litellm` databases on first initialization.

> **Note:** The init script only runs when the `postgres-data` volume is created for the first time. To re-run it, remove the volume:
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

# View logs
docker compose logs -f

# View logs for a specific service
docker compose logs -f litellm

# Restart a single service
docker compose restart n8n

# Reset everything (removes all data)
docker compose down -v
docker compose up -d
```

## Networking

All services communicate over a shared Docker network named `local`. Internal service hostnames:

| Hostname   | Port |
| ---------- | ---- |
| `postgres` | 5432 |
| `litellm`  | 4000 |
| `n8n`      | 5678 |
| `openwebui`| 8080 |
