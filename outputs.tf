output "users" {
  value = {
    _password = var.user_password
    admin     = okta_user.tfeadmin.email
    user1     = okta_user.user1.email
    user2     = okta_user.user2.email
    user3     = okta_user.user3.email
  }
}
