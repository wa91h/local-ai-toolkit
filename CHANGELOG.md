# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.1.3] - 2026-04-26

### Added
- Healthchecks for `postgres`, `litellm`, and `n8n` services
- `depends_on` conditions so `litellm` and `n8n` wait for Postgres to be healthy, and `openwebui` waits for LiteLLM
- Open WebUI auto-configured to connect to LiteLLM via environment variables (`OPENAI_API_BASE_URL`, `OPENAI_API_KEY`)
- GitHub Actions workflow to validate `docker-compose.yml` syntax on every push and PR
- `CONTRIBUTING.md` with guidelines for adding models and reporting issues
- Troubleshooting section and architecture diagram in README

## [0.1.2] - 2026-04-24

### Added
- Ollama Cloud models: `gemma4`, `glm-5.1`, `kimi-k2.6`, `deepseek-v4-flash`

## [0.1.1] - 2026-03-24

### Added
- Ollama Cloud models: `minimax-m2.5`, `nemotron-3-super`

## [0.1.0] - 2026-02-25

### Added
- Initial stack: LiteLLM, n8n, Open WebUI, PostgreSQL via Docker Compose
- ~35 pre-configured Ollama Cloud models (DeepSeek, Qwen3, Gemma3, Mistral, Kimi-K2, and more)
- Shared PostgreSQL instance with automatic database initialization (`init_db.sh`)
- External `ai-toolkit` Docker network for inter-container communication
- JSON log rotation (`max-size: 5m`) on all services
- `restart: unless-stopped` policy on all services
