{{/* Common labels */}}
{{- define "ns-go.labels" -}}
helm.sh/chart: {{ include "ns-go.version" . }}
{{ include "ns-go.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Common selector labels */}}
{{- define "ns-go.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ns-go.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/* Common selector labels */}}
{{- define "ns-go.common.selectorLabels" -}}
{{ include "ns-go.selectorLabels" . }}
app.kubernetes.io/component: common
{{- end }}

{{/* Common labels */}}
{{- define "ns-go.common.labels" -}}
{{ include "ns-go.labels" . }}
app.kubernetes.io/component: common
{{- end }}
