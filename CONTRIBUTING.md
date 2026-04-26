# Contributing

Contributions are welcome — bug reports, new model configurations, and documentation improvements included.

## Getting Started

1. Fork the repository and create a branch from `main`
2. Follow the [Quick Start](README.md#quick-start) to get the stack running locally
3. Make your changes, test them locally, then open a pull request

## What to Contribute

### Adding or updating models

Add entries to `config/litellm_config.yaml` and verify they work:
```bash
docker compose restart litellm
curl http://localhost:4000/v1/models -H "Authorization: Bearer $LITELLM_MASTER_KEY"
```

### Changing service configuration

Edit `docker-compose.yml`. After changes, validate the syntax before opening a PR:
```bash
docker compose config --quiet
```

### Documentation

README and inline comments are in plain Markdown. Keep the troubleshooting section up to date when adding new services or configuration options.

## Pull Request Guidelines

- Keep PRs focused — one change per PR
- For new model additions, include the model name and provider in the PR title (e.g. `feat: add gemma3:27b via Ollama Cloud`)
- Update the [CHANGELOG](CHANGELOG.md) under `Unreleased`

## Reporting Issues

Open a GitHub issue with:
- Your OS and Docker version (`docker --version`, `docker compose version`)
- The relevant service logs (`docker compose logs <service>`)
- Your `.env` with secrets redacted
