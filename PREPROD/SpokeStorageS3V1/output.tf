output "subscription_id" {
  value = "${data.azurerm_client_config.current.subscription_id}"
}
output "logging_hub_loganalytics_stor_log_repo_out" {
  value = "${module.logging.hub-corpc-sto-acc-log-endpoint}"
}

output "logging_hub_loganalytics_stor_log_repo_name_out" {
  value = "${module.logging.hub-corpc-sto-acc-log-name}"
}

output "logging_hub_loganalytics_stor_log_repo_sas_out" {
  value = "${module.logging.hub-corpc-sto-acc-log-sas-url-string}"
}

output "logging_hub_loganalytics_ws_id_out" {
  value = "${module.logging.hub-corpc-log-ana-rep-primary-workspace-id}"
}

output "logging_hub_loganalytics_ws_key_out" {
  value = "${module.logging.hub-corpc-log-ana-rep-primary-key}"
}

