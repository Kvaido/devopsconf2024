{{/*
Common labels
*/}}
{{- define "ns-go.labels" -}}
helm.sh/chart: {{ include "ns-go.version" . }}
{{ include "ns-go.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Common selector labels
*/}}
{{- define "ns-go.selectorLabels" -}}
app.kubernetes.io/name: {{ include "ns-go.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Main selector labels
*/}}
{{- define "ns-go.main.selectorLabels" -}}
{{ include "ns-go.selectorLabels" . }}
app.kubernetes.io/component: main
{{- end }}

{{/*
Main labels
*/}}
{{- define "ns-go.main.labels" -}}
{{ include "ns-go.labels" . }}
app.kubernetes.io/component: main
{{- end }}
