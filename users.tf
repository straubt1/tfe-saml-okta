locals {
  user_site_admin = replace(var.personal_email, "@", "+tfeadmin@")
  user1           = replace(var.personal_email, "@", "+tfeuser1@")
  user2           = replace(var.personal_email, "@", "+tfeuser2@")
  user3           = replace(var.personal_email, "@", "+tfeuser3@")
}

resource "okta_user" "tfeadmin" {
  first_name = "T"
  last_name  = "Siteadmin"
  login      = local.user_site_admin
  email      = local.user_site_admin
  password   = var.user_password

  custom_profile_attributes = jsonencode({
    TFESiteAdmin = true
  })
}

resource "okta_user" "user1" {
  first_name = "T"
  last_name  = "User1"
  login      = local.user1
  email      = local.user1
  password   = var.user_password
}

resource "okta_user" "user2" {
  first_name = "T"
  last_name  = "User2"
  login      = local.user2
  email      = local.user2
  password   = var.user_password
}

resource "okta_user" "user3" {
  first_name = "T"
  last_name  = "User3"
  login      = local.user3
  email      = local.user3
  password   = var.user_password
}

resource "okta_app_user" "siteadmin" {
  app_id   = okta_app_saml.tfe.id
  user_id  = okta_user.tfeadmin.id
  username = okta_user.tfeadmin.email
}
