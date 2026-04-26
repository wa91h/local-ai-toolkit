# Security Policy

## Supported Versions

| Version | Supported |
|---|---|
| latest (main) | yes |

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Report vulnerabilities by emailing **w.ourimi@gmail.com** with:

- A description of the vulnerability and its potential impact
- Steps to reproduce or a proof of concept
- Any suggested fix if you have one

You will receive a response within 72 hours. Once the issue is confirmed, a fix will be released as soon as possible.

## Scope

This project is infrastructure configuration (Docker Compose + Helm). Security issues in scope include:

- Credentials or secrets accidentally exposed in configuration files
- Insecure default settings that could lead to unauthorized access
- Misconfigurations in the Helm chart that weaken security posture

Issues in upstream projects (LiteLLM, n8n, Open WebUI, PostgreSQL) should be reported directly to those projects.
