{{/*
Expand the name of the chart.
*/}}
{{- define "ns-go.name" -}}
{{- default .Chart.Name .Values.main.nameOverride | trunc 63 | trimSuffix "-" }}
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
{{- if .Values.main.fullnameOverride }}
{{- .Values.main.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.main.nameOverride }}
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

{{/*Main annotations*/}}
{{- define "ns-go.main.annotations" -}}
{{ include "ns-go.annotations" . }}
{{- with .Values.main.annotations }}
{{- include "quote.object" . -}}
{{- end -}}
{{- end }}

{{/*
Annotations of checksums for configs and secrets of all pods.
*/}}
{{- define "ns-go.checksumPodAnnotations" -}}
checksum/config: {{ include (print $.Template.BasePath "/configmap.yaml") . | sha256sum }}
checksum/secret: {{ include (print $.Template.BasePath "/secret.yaml") . | sha256sum }}
{{- end }}

{{/*
podAntiAffinity soft template
*/}}
{{- define "ns-go.main.podAntiAffinity.soft" -}}
podAntiAffinity:
  preferredDuringSchedulingIgnoredDuringExecution:
    - podAffinityTerm:
        topologyKey: kubernetes.io/hostname
        labelSelector:
          matchLabels:
            {{- include "ns-go.main.selectorLabels" . | nindent 12 }}
      weight: 100
{{- end }}

{{/*
podAntiAffinity hard template
*/}}
{{- define "ns-go.main.podAntiAffinity.hard" -}}
podAntiAffinity:
  requiredDuringSchedulingIgnoredDuringExecution:
    - topologyKey: kubernetes.io/hostname
      labelSelector:
        matchLabels:
          {{- include "ns-go.main.selectorLabels" . | nindent 10 }}
{{- end }}