# ai-toolkit

A Helm chart for the **AI Local Toolkit** — a self-hosted AI stack bundling an LLM gateway, workflow automation, and a chat UI backed by PostgreSQL.

## Services

| Service | Description | Default port |
|---|---|---|
| **LiteLLM** | OpenAI-compatible LLM API gateway | 4000 |
| **n8n** | Visual workflow automation | 5678 |
| **Open WebUI** | ChatGPT-like interface | 8080 |
| **PostgreSQL** | Shared database (LiteLLM + n8n) | 5432 |

## Prerequisites

- Kubernetes 1.21+
- Helm 3.8+
- An [Ollama Cloud](https://ollama.com) account and API key

## Installing the chart

```bash
helm install ai-toolkit oci://ghcr.io/wa91h/charts/ai-toolkit \
  --namespace ai-toolkit --create-namespace \
  --set litellm.masterKey=sk-... \
  --set litellm.saltKey=sk-... \
  --set litellm.ollamaApiKey=... \
  --set postgresql.auth.password=...
```

Or with a values file:

```bash
helm install ai-toolkit oci://ghcr.io/wa91h/charts/ai-toolkit \
  --namespace ai-toolkit --create-namespace \
  -f my-values.yaml
```

## Parameters

### Global

| Parameter | Description | Default |
|---|---|---|
| `postgresql.enabled` | Deploy the bundled PostgreSQL instance | `true` |
| `litellm.enabled` | Deploy LiteLLM | `true` |
| `n8n.enabled` | Deploy n8n | `true` |
| `openwebui.enabled` | Deploy Open WebUI | `true` |

### LiteLLM

| Parameter | Description | Default |
|---|---|---|
| `litellm.masterKey` | LiteLLM master API key (required) | `""` |
| `litellm.saltKey` | LiteLLM salt key for hashing (required) | `""` |
| `litellm.ollamaApiKey` | Ollama Cloud API key (required) | `""` |
| `litellm.replicaCount` | Number of replicas | `1` |
| `litellm.image.tag` | Image tag | `main-stable` |
| `litellm.resources` | CPU/memory resource requests and limits | see values.yaml |
| `litellm.service.port` | Service port | `4000` |

### n8n

| Parameter | Description | Default |
|---|---|---|
| `n8n.replicaCount` | Number of replicas | `1` |
| `n8n.image.tag` | Image tag | `latest` |
| `n8n.timezone` | IANA timezone for workflow scheduling | `UTC` |
| `n8n.persistence.enabled` | Enable persistent storage | `true` |
| `n8n.persistence.size` | PVC size | `1Gi` |
| `n8n.resources` | CPU/memory resource requests and limits | see values.yaml |
| `n8n.service.port` | Service port | `5678` |

### Open WebUI

| Parameter | Description | Default |
|---|---|---|
| `openwebui.replicaCount` | Number of replicas | `1` |
| `openwebui.image.tag` | Image tag | `main` |
| `openwebui.persistence.enabled` | Enable persistent storage | `true` |
| `openwebui.persistence.size` | PVC size | `2Gi` |
| `openwebui.resources` | CPU/memory resource requests and limits | see values.yaml |
| `openwebui.service.port` | Service port | `8080` |

### PostgreSQL

| Parameter | Description | Default |
|---|---|---|
| `postgresql.auth.database` | Default database name | `postgres` |
| `postgresql.auth.username` | Database username | `postgres` |
| `postgresql.auth.password` | Database password (required) | `""` |
| `postgresql.image.tag` | PostgreSQL image tag | `16-alpine` |
| `postgresql.persistence.enabled` | Enable persistent storage | `true` |
| `postgresql.persistence.size` | PVC size | `5Gi` |

### External database

To use an external PostgreSQL instead of the bundled one:

```yaml
postgresql:
  enabled: false

externalDatabase:
  host: my-db.example.com
  port: 5432
  username: postgres
  password: secret
  database: postgres
```

The external server must already have `n8n` and `litellm` databases created.

### Ingress

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

## Accessing services without Ingress

```bash
kubectl port-forward svc/ai-toolkit-litellm 4000:4000
kubectl port-forward svc/ai-toolkit-n8n 5678:5678
kubectl port-forward svc/ai-toolkit-openwebui 3000:8080
```

## Upgrading

```bash
helm upgrade ai-toolkit oci://ghcr.io/wa91h/charts/ai-toolkit -f my-values.yaml
```

## Uninstalling

```bash
helm uninstall ai-toolkit
```

> PersistentVolumeClaims are **not** deleted automatically. Remove them manually if you want to purge all data:
> ```bash
> kubectl delete pvc -l app.kubernetes.io/instance=ai-toolkit
> ```

## Models

37 Ollama Cloud models are pre-configured across 10 providers (DeepSeek, Qwen, Google, OpenAI, Mistral, Kimi, MiniMax, GLM, NVIDIA, Cogito). See the [full model list](https://github.com/wa91h/local-ai-toolkit/blob/main/models.md).

## Source

[https://github.com/wa91h/local-ai-toolkit](https://github.com/wa91h/local-ai-toolkit)
