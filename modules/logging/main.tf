locals {
  notification_email = [ var.user_email , var.admin_email ]
}

resource "google_monitoring_notification_channel" "email_alerts" {
  for_each     = toset(local.notification_email)
  display_name = "Security Alert - ${each.value}"
  type         = "email"
  labels = {
    email_address = each.value
  }
}

# 2. Create the Notebook-Specific Alert Policy
resource "google_monitoring_alert_policy" "unique_iap_alert" {
  display_name = "Unauthorized Access - ${var.instance_name}"
  combiner     = "OR"
  
  conditions {
    display_name = "IAP Denied - ${var.instance_name}"
    condition_matched_log {
      # The filter targets IAP denials that specifically contain this notebook's name
      filter = "resource.type=\"iap_web\" AND protoPayload.status.code=7 AND \"${var.instance_name}\""
    }
  }

  notification_channels = [
    for channel in google_monitoring_notification_channel.email_alerts :
    channel.name
  ]

  alert_strategy {
    notification_rate_limit {
      period = "3600s" # Limits spam to a maximum of 1 email per hour per notebook
    }
  }
}