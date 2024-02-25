{{/*
Expand the name of the chart.
*/}}
{{- define "ns-go.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Sanitizes given string. */}}
{{- define "sanitize" -}}
{{- $name := regexReplaceAll "[[:^alnum:]]" . "-" -}}
{{- regexReplaceAll "-+" $name "-" | lower | trunc 63 | trimAll "-" -}}
{{- end -}}

{{/* Quotes items of the given list. */}}
{{- define "quote.list" -}}
{{- range $item := . }}
- {{ $item | quote }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "ns-go.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "ns-go.version" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create the name of the service account to use.
*/}}
{{- define "ns-go.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "ns-go.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/* Quotes values of the given object. */}}
{{- define "quote.object" -}}
{{- range $key, $value := . }}
{{ $key }}: {{ $value | quote }}
{{- end -}}
{{- end -}}

{{/* Expand annotation labels of the chart. */}}
{{- define "ns-go.annotations" -}}
{{- with .Values.annotations }}
{{- include "quote.object" . -}}
{{- end -}}
{{- end -}}

{{/* Common annotations */}}
{{- define "ns-go.common.annotations" -}}
{{ include "ns-go.annotations" . }}
{{- with .Values.common.annotations }}
{{- include "quote.object" . -}}
{{- end -}}
{{- end }}

{{/* Migrations annotations */}}
{{- define "ns-go.migrations.annotations" -}}
{{- include "ns-go.annotations" . }}
{{- with .Values.migrations.annotations }}
{{- include "quote.object" . }}
{{- end }}
{{- end }}

{{/* Migrations config annotations */}}
{{- define "ns-go.migrations.configAnnotations" -}}
{{- include "ns-go.annotations" . }}
{{- with .Values.migrations.configAnnotations }}
{{- include "quote.object" . }}
{{- end }}
{{- end }}

{{/*
Annotations of checksums for configs and secrets of all pods.
*/}}
{{- define "ns-go.checksumPodAnnotations" -}}
checksum/config: {{ include (print $.Template.BasePath "/main-cm.yaml") . | sha256sum }}
checksum/secret: {{ include (print $.Template.BasePath "/main-secret.yaml") . | sha256sum }}
checksum/config-logging: {{ include (print $.Template.BasePath "/main-cm-logging.yaml") . | sha256sum }}
checksum/secret-logging: {{ include (print $.Template.BasePath "/common-secret-logging.yaml") . | sha256sum }}
{{- end }}
