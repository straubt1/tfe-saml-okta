variable "tfe_hostname" {
  description = "The hostname of TFE, example: 'tfe.company.com'"
}

variable "personal_email" {
  type        = string
  description = "Personal email to use when creating users."
}

variable "user_password" {
  type        = string
  description = "Password to use for users. Just use the same one for all, #security."
}
