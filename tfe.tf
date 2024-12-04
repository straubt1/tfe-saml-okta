# Configure TFE with the Okta Application
resource "tfe_saml_settings" "tfe" {
  site_admin_role         = "site-admin"
  team_management_enabled = true
  slo_endpoint_url        = okta_app_saml.tfe.http_post_binding
  sso_endpoint_url        = okta_app_saml.tfe.http_post_binding
  idp_cert                = "-----BEGIN CERTIFICATE-----\n${okta_app_saml.tfe.certificate}\n-----END CERTIFICATE-----"
}
