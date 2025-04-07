{{/*
Return the name of the chart or overridden name
*/}}
{{- define "symfony.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
Return the full name of the release or overridden full name
*/}}
{{- define "symfony.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name (include "symfony.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
