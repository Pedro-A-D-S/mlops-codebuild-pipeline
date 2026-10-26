# Datadog Observability as Code: Automated latency, error rate & drift monitors

variable "environment" {
  type    = string
  default = "production"
}

variable "alert_notification_channel" {
  type    = string
  default = "@slack-mlops-alerts"
}

# In a live setup with datadog provider configured:
# resource "datadog_monitor" "inference_latency_p99" { ... }
# Here modeled cleanly for zero cloud cost dry-run.

locals {
  datadog_monitors = {
    p99_latency = {
      name    = "[MLOps] Inference Latency P99 > 150ms on ${var.environment}"
      type    = "metric alert"
      query   = "avg(last_5m):p99:trace.ml.inference.duration{env:${var.environment}} > 0.15"
      message = "ML Inference p99 latency exceeded 150ms SLA. Investigating autoscaling. ${var.alert_notification_channel}"
    }
    error_rate_5xx = {
      name    = "[MLOps] Inference 5xx Error Rate > 1% on ${var.environment}"
      type    = "metric alert"
      query   = "sum(last_5m):sum:trace.ml.inference.errors{env:${var.environment}}.as_count() / sum:trace.ml.inference.hits{env:${var.environment}}.as_count() > 0.01"
      message = "High 5xx error rate detected in ML inference endpoints! ${var.alert_notification_channel}"
    }
    data_drift = {
      name    = "[MLOps] Kolmogorov-Smirnov Feature Drift Alert on ${var.environment}"
      type    = "metric alert"
      query   = "max(last_1h):ml.feature_drift.p_value{env:${var.environment}} < 0.05"
      message = "Statistically significant feature drift detected. Triggering automated model retraining pipeline. ${var.alert_notification_channel}"
    }
  }
}

output "monitors_configured" {
  value = keys(local.datadog_monitors)
}
