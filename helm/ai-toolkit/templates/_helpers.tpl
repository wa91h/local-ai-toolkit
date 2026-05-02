{{- define "ai-toolkit.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ai-toolkit.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{- define "ai-toolkit.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "ai-toolkit.labels" -}}
helm.sh/chart: {{ include "ai-toolkit.chart" . }}
{{ include "ai-toolkit.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "ai-toolkit.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ai-toolkit.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Name of the shared secret */}}
{{- define "ai-toolkit.secretName" -}}
{{- printf "%s-secrets" (include "ai-toolkit.fullname" .) }}
{{- end }}

{{/* PostgreSQL service host */}}
{{- define "ai-toolkit.postgresHost" -}}
{{- if .Values.postgresql.enabled }}
{{- printf "%s-postgresql" (include "ai-toolkit.fullname" .) }}
{{- else }}
{{- required "externalDatabase.host is required when postgresql.enabled is false" .Values.externalDatabase.host }}
{{- end }}
{{- end }}

{{/* PostgreSQL port */}}
{{- define "ai-toolkit.postgresPort" -}}
{{- if .Values.postgresql.enabled }}
{{- "5432" }}
{{- else }}
{{- .Values.externalDatabase.port | toString }}
{{- end }}
{{- end }}

{{/* PostgreSQL username */}}
{{- define "ai-toolkit.postgresUser" -}}
{{- if .Values.postgresql.enabled }}
{{- .Values.postgresql.auth.username }}
{{- else }}
{{- .Values.externalDatabase.username }}
{{- end }}
{{- end }}

{{/* PostgreSQL database (default/admin db, not service-specific ones) */}}
{{- define "ai-toolkit.postgresDatabase" -}}
{{- if .Values.postgresql.enabled }}
{{- .Values.postgresql.auth.database }}
{{- else }}
{{- .Values.externalDatabase.database }}
{{- end }}
{{- end }}

{{/* Redis service host */}}
{{- define "ai-toolkit.redisHost" -}}
{{- if .Values.redis.enabled }}
{{- printf "%s-redis" (include "ai-toolkit.fullname" .) }}
{{- else }}
{{- required "externalRedis.host is required when redis.enabled is false and n8n.queueMode.enabled is true" .Values.externalRedis.host }}
{{- end }}
{{- end }}

{{/* Redis port */}}
{{- define "ai-toolkit.redisPort" -}}
{{- if .Values.redis.enabled }}
{{- .Values.redis.service.port | toString }}
{{- else }}
{{- .Values.externalRedis.port | toString }}
{{- end }}
{{- end }}

{{/* Redis database index (for QUEUE_BULL_REDIS_DB) */}}
{{- define "ai-toolkit.redisDatabase" -}}
{{- if .Values.redis.enabled }}
{{- "0" }}
{{- else }}
{{- .Values.externalRedis.database | default 0 | toString }}
{{- end }}
{{- end }}

{{/* Whether a Redis password is configured (controls whether to inject the env var) */}}
{{- define "ai-toolkit.redisHasPassword" -}}
{{- if .Values.redis.enabled }}
{{- if .Values.redis.auth.password }}true{{ end }}
{{- else }}
{{- if .Values.externalRedis.password }}true{{ end }}
{{- end }}
{{- end }}
