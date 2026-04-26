# AI Local Toolkit

A self-hosted AI stack bundling an LLM gateway, workflow automation, and a chat UI — all backed by a shared PostgreSQL database. Deployable locally with Docker Compose or on any Kubernetes cluster via Helm.

All free [Ollama Cloud](https://ollama.com) models are pre-configured out of the box. Create an Ollama account, generate an API key, and you're ready to go.

> **⚠️ Warning:** This project is not production-ready out of the box. It has no TLS, no authentication proxy, no secrets management, and no backup strategy. It is safe for local use and trusted internal networks. See [Production Checklist](#production-checklist) before exposing it to the internet or running it with real data.

## Services

| Service        | Description                          | Docker Compose URL       |
| -------------- | ------------------------------------ | ------------------------ |
| **LiteLLM**    | OpenAI-compatible LLM API gateway    | http://localhost:4000    |
| **LiteLLM UI** | Admin dashboard                      | http://localhost:4000/ui |
| **n8n**        | Visual workflow automation           | http://localhost:5678    |
| **Open WebUI** | ChatGPT-like interface               | http://localhost:3000    |

## Architecture

```
┌─────────────┐              ┌─────────────┐
│  Open WebUI │              │     n8n     │
└──────┬──────┘              └──────┬──┬───┘
       │                            │  │
       │    OpenAI-compatible API   │  │ workflow storage
       └─────────────┬──────────────┘  │
                     ▼                 ▼
              ┌────────────┐    ┌────────────┐
              │  LiteLLM   │───▶│ PostgreSQL │
              └─────┬──────┘    └────────────┘
                    │
              Ollama Cloud
              (37+ models)
```

Services communicate internally by container/pod name. Open WebUI is pre-wired to LiteLLM — no manual configuration needed.

## Prerequisites

- An [Ollama Cloud](https://ollama.com) account and API key
- **Docker Compose:** Docker Engine + Docker Compose plugin
- **Kubernetes:** a running cluster + [Helm 3](https://helm.sh/docs/intro/install/)

---

## Deployment

### Option A — Docker Compose (local)

**1. Create the shared network** *(one-time)*
```bash
docker network create ai-toolkit
```

**2. Configure environment**
```bash
cp .env.dist .env
```
Edit `.env`:
```dotenv
POSTGRES_DB=postgres
POSTGRES_USER=postgres
POSTGRES_PASSWORD=<your_secure_password>

LITELLM_MASTER_KEY=sk-<generate_a_key>
LITELLM_SALT_KEY=sk-<generate_a_key>
OLLAMA_API_KEY=<your_ollama_api_key>

TZ=America/New_York   # IANA timezone
```

**3. Start the stack**
```bash
docker compose up -d
```

**4. Verify**
```bash
docker compose ps   # wait until all services show "healthy"
```

**Disabling services** *(optional)*

Edit `COMPOSE_PROFILES` in `.env` to remove services you don't need:
```dotenv
# All enabled (default)
COMPOSE_PROFILES=litellm,n8n,openwebui

# Without n8n
COMPOSE_PROFILES=litellm,openwebui

# LiteLLM only (no UI, no automation)
COMPOSE_PROFILES=litellm
```
> Postgres always runs — it is not profile-gated since other services depend on it.
> Disabling `litellm` requires also removing `openwebui` (it depends on LiteLLM).

---

### Option B — Kubernetes / Helm

**1. Install the chart**
```bash
helm install ai-toolkit ./helm/ai-toolkit \
  --set litellm.masterKey=sk-... \
  --set litellm.saltKey=sk-... \
  --set litellm.ollamaApiKey=... \
  --set postgresql.auth.password=...
```

For repeatable installs, use a values file instead of `--set` flags:
```bash
# my-values.yaml
litellm:
  masterKey: sk-...
  saltKey: sk-...
  ollamaApiKey: ...

postgresql:
  auth:
    password: ...
```
```bash
helm install ai-toolkit ./helm/ai-toolkit -f my-values.yaml
```

**2. Access services** *(without Ingress)*
```bash
kubectl port-forward svc/ai-toolkit-litellm 4000:4000
kubectl port-forward svc/ai-toolkit-n8n 5678:5678
kubectl port-forward svc/ai-toolkit-openwebui 3000:8080
```

**3. Enable Ingress** *(optional)*

Add to your values file:
```yaml
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    litellm: litellm.example.com
    n8n: n8n.example.com
    openwebui: chat.example.com
  tls:
    - secretName: ai-toolkit-tls
      hosts:
        - litellm.example.com
        - n8n.example.com
        - chat.example.com
```

**4. Use an external database** *(optional)*

To disable the bundled PostgreSQL and point to your own (e.g. RDS, Cloud SQL):
```yaml
postgresql:
  enabled: false

externalDatabase:
  host: my-db.example.com
  port: 5432
  username: postgres
  password: ...
  database: postgres
```
The external server must already have `n8n` and `litellm` databases created.

**5. Disable individual services** *(optional)*
```yaml
n8n:
  enabled: false   # skip n8n if you don't need workflow automation

openwebui:
  enabled: false   # skip Open WebUI if you use a different frontend
```

**Upgrade / uninstall**
```bash
helm upgrade ai-toolkit ./helm/ai-toolkit -f my-values.yaml
helm uninstall ai-toolkit
```

---

## Project Structure

```
.
├── docker-compose.yml            # Docker Compose stack definition
├── .env.dist                     # Environment variables template
├── config/
│   ├── litellm_config.yaml       # LiteLLM model registry (37 Ollama Cloud models)
│   └── init_db.sh                # Creates n8n & litellm databases on first run
├── helm/
│   └── ai-toolkit/               # Helm chart for Kubernetes
│       ├── Chart.yaml
│       ├── values.yaml           # All chart defaults, fully annotated
│       └── templates/            # K8s manifests (Deployments, Services, PVCs, …)
└── .github/
    └── workflows/
        └── validate.yml          # CI: validates compose file and Helm chart
```

## Configuration

### Adding or updating models

Append to `config/litellm_config.yaml` (Docker Compose) or override `litellm.config` in your Helm values:

```yaml
- model_name: my-model
  litellm_params:
    model: ollama_chat/<model-id>
    api_base: https://ollama.com
    api_key: os.environ/OLLAMA_API_KEY
```

Docker Compose: `docker compose restart litellm`
Kubernetes: `helm upgrade ai-toolkit ./helm/ai-toolkit -f my-values.yaml`

### Calling the LiteLLM API directly

```bash
curl http://localhost:4000/v1/models \
  -H "Authorization: Bearer $LITELLM_MASTER_KEY"
```

### PostgreSQL databases

A single PostgreSQL 16 instance hosts two databases: `n8n` and `litellm`. The `config/init_db.sh` script creates them on first startup and is idempotent (safe to re-run).

To reset the database (Docker Compose):
```bash
docker compose down
docker volume rm toolkit_postgres-data
docker compose up -d
```

---

## Docker Compose — Useful Commands

```bash
docker compose up -d                    # start all services
docker compose down                     # stop all services
docker compose ps                       # show service health
docker compose logs -f litellm          # tail logs for one service
docker compose restart litellm          # reload after config change
docker compose down -v && docker compose up -d  # full reset (deletes data)
```

---

## Troubleshooting

**`docker compose up` fails with "network ai-toolkit not found"**
```bash
docker network create ai-toolkit
```

**Services stay `starting` or `unhealthy`**
LiteLLM and n8n wait for Postgres to pass its healthcheck before starting. On first run, Postgres runs the init script which can take 20–30 s. Check progress:
```bash
docker compose logs -f postgres
```

**Open WebUI shows no models**
Verify LiteLLM is healthy (`docker compose ps`) and that `OLLAMA_API_KEY` is set correctly in `.env`:
```bash
docker compose logs -f litellm
```

**n8n can't connect to the database**
The `POSTGRES_USER` and `POSTGRES_PASSWORD` in `.env` must match what was used when the `postgres-data` volume was first created. If they changed, reset the volume or revert the credentials.

**Port already in use**
Change the host-side port in `docker-compose.yml`, e.g. `"4001:4000"` for LiteLLM.

**Helm pod stuck in `Pending`**
The cluster likely has no default StorageClass for PVCs. Either install one or set `persistence.storageClass` in your values to an available class:
```bash
kubectl get storageclass
```

---

## Production Checklist

This stack ships with sane defaults for development and internal use. The items below are required before running it with real users or sensitive data.

### Must-have

| Item | How |
|---|---|
| **TLS** | Add cert-manager to your cluster and set `ingress.annotations` with a ClusterIssuer. All traffic is plain HTTP by default. |
| **Authentication proxy** | Put [oauth2-proxy](https://oauth2-proxy.github.io/oauth2-proxy/) or [Authelia](https://www.authelia.com/) in front of every public-facing service. None of the services (LiteLLM UI, n8n, Open WebUI) require login by default. |
| **Secrets management** | `.env` files and K8s Secrets store credentials in plaintext / base64. Use [External Secrets Operator](https://external-secrets.io/) with AWS Secrets Manager, GCP Secret Manager, or Vault to inject secrets at runtime. |
| **PostgreSQL backups** | Deploy a `pg_dump` CronJob or use [Velero](https://velero.io/) for volume snapshots. There is no backup strategy included. Data loss = permanent loss of n8n workflows and LiteLLM audit logs. |
| **Pin image tags** | `main-stable`, `latest`, and `main` are mutable — a re-pull can silently introduce a breaking change. Pin to a specific version in `values.yaml` (e.g. `tag: "v1.45.0"`) for reproducible deployments. |

### Should-have

| Item | How |
|---|---|
| **n8n secure cookies** | `N8N_SECURE_COOKIE=false` is forced because there is no HTTPS by default. Once TLS is in place, remove that override from `n8n-deployment.yaml`. |
| **Network policies** | By default every pod can reach every other pod. Add Kubernetes NetworkPolicy resources to restrict postgres and litellm to only their direct consumers. |
| **Resource tuning** | The default resource limits in `values.yaml` are starting points. Profile your actual workload and adjust — especially PostgreSQL memory if you have large n8n execution history. |
| **Monitoring** | Add [Prometheus](https://prometheus.io/) + [Grafana](https://grafana.com/) to the cluster. LiteLLM exposes Prometheus metrics at `/metrics`. |
