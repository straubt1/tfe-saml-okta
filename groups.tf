locals {
  group_site_admin = "TFE Site Admin"
  group_all_users  = "TFE All Users"
  group_developers = "TFE Developers"
}

resource "okta_group" "site_admin" {
  name        = local.group_site_admin
  description = "Users in this group will be site administrators for all of TFE."
}

resource "okta_group" "all" {
  name        = local.group_all_users
  description = "All users will go into this group and give TFE App Access, but not specific organizations."
}

resource "okta_group" "developers" {
  name        = local.group_developers
  description = "Users in this group will have some arbitrary and limited access to demonstrate RBAC."
}

resource "okta_app_group_assignments" "tfe" {
  app_id = okta_app_saml.tfe.id
  group {
    id       = okta_group.all.id
    priority = 1
  }
  group {
    id       = okta_group.site_admin.id
    priority = 2
  }
  group {
    id       = okta_group.developers.id
    priority = 3
  }
}

# All Users
resource "okta_group_memberships" "all" {
  group_id = okta_group.all.id
  users = [
    okta_user.tfeadmin.id,
    okta_user.user1.id,
    okta_user.user2.id,
    okta_user.user3.id,
  ]
}

# Single Site Admin
resource "okta_group_memberships" "siteadmin" {
  group_id = okta_group.site_admin.id
  users    = [okta_user.tfeadmin.id]
}

# Select users for Developer Group
resource "okta_group_memberships" "developers" {
  group_id = okta_group.developers.id
  users = [
    okta_user.user2.id,
    okta_user.user3.id,
  ]
}
