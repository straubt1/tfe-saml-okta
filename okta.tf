# Okta Application for TFE
resource "okta_app_saml" "tfe" {
  logo                     = "./images/TFE.png"
  label                    = "Terraform Enterprise (${var.tfe_hostname})"
  sso_url                  = "https://${var.tfe_hostname}/users/saml/auth"
  recipient                = "https://${var.tfe_hostname}/users/saml/auth"
  destination              = "https://${var.tfe_hostname}/users/saml/auth"
  audience                 = "https://${var.tfe_hostname}/users/saml/metadata"
  subject_name_id_template = "$${user.userName}"
  user_name_template       = "$${source.email}"
  authn_context_class_ref  = "urn:oasis:names:tc:SAML:2.0:ac:classes:PasswordProtectedTransport"
  subject_name_id_format   = "urn:oasis:names:tc:SAML:1.1:nameid-format:emailAddress"
  signature_algorithm      = "RSA_SHA256"
  digest_algorithm         = "SHA256"
  assertion_signed         = true
  response_signed          = true
  honor_force_authn        = true

  attribute_statements {
    name      = "SiteAdmin"
    namespace = "urn:oasis:names:tc:SAML:2.0:attrname-format:basic"
    type      = "EXPRESSION"
    values = [
      "user.TFESiteAdmin", #This will be created manually in the Okta Portal.
    ]
  }
  attribute_statements {
    namespace    = "urn:oasis:names:tc:SAML:2.0:attrname-format:basic"
    type         = "GROUP"
    name         = "MemberOf"
    filter_type  = "STARTS_WITH" #This is a simple filter, but can be whatever you like.
    filter_value = "TFE"
  }
}
