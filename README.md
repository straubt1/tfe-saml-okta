# tfe-saml-okta

Easily create a SSO setup with Okta for TFE testing and development.

This setup is meant for a quick way to setup an ephemeral SSO setup for TFE. While these constructs can certainly be used as inspiration for a production installation, use caution and verify all settings.

See the [Getting Started](#getting-started) section to setup your environment.

## Terraform Runs

The Terraform files will create the following:

* Okta SAML Application
* TFE SAML Settings (linking TFE to the Okta SAML Application)
* 3 Okta Groups
  * "TFE Site Admin" - Will have Site Admin permissions
  * "TFE All Users" - Will have general TFE Access, but no specific Organizations
  * "TFE Developers" - Will have access to a specific Project
* 1 Site Admin User ("tfeadmin")
  * Will all be assigned to the "TFE All Users" Okta Group
  * Will be assigned to the "TFE Site Admin" Okta Group
* 3 General Users ("tfeuser{n}")
  * Will all be assigned to the "TFE All Users" Okta Group
  * Some will be assigned to the "TFE Developers" Okta Group

### Setting Environment Variables

Rather than setting these sensitive values as Terraform Values, we set them as Environment Variables.

Okta Values from the "Terraform API Access" created in the [Create API Application](#create-api-application) section:
```
export OKTA_ORG_NAME="dev-0000"
export OKTA_BASE_URL="okta.com"
export OKTA_API_SCOPES="okta.apps.manage,okta.brands.manage,okta.policies.manage,okta.enduser.manage,okta.users.manage,okta.groups.manage,okta.schemas.manage"
export OKTA_API_CLIENT_ID="0o..."
export OKTA_API_PRIVATE_KEY=$(cat <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvA...
....
-----END PRIVATE KEY-----
EOF
)
```

Terraform Enterprise Values:

```
export TFE_HOSTNAME="tfe.company.com"
export TFE_TOKEN="aaa.atlasv1.cccc"
```

### Terraform Time

You are ready to run `terraform apply`.

If all goes well, you should see something like this:

```
Apply complete! Resources: 0 added, 1 changed, 0 destroyed.

Outputs:

users = {
  "_password" = "{My User Password}"
  "admin"     = "myemail+tfeadmin@gmail.com"
  "user1"     = "myemail+tfeuser1@gmail.com"
  "user2"     = "myemail+tfeuser2@gmail.com"
  "user3"     = "myemail+tfeuser3@gmail.com"
}
```

You can now login to TFE via SAML using the emails and password.

Play around with TFE Team assignments.

- [ ] TODO: Add Terraform to create an Organization, Teams, and Workspaces.

## Getting Started

There are a few things you will need to get started:

- A running TFE instance that is publicly accessible.
- A company email address (used for an Okta Admin).
- A personal email address, preferably gmail (used for the test users we will create).
  - We will leverage "plus addressing" to avoid the need to need a new email account for each test user.

The next steps are unfortunately manual (:chicken: meet :egg:)

### Create an Okta Dev Account

Navigate to https://developer.okta.com/signup/, in the Workforce Identity Cloud section select the "Sign up for free Developer Edition". This is the option on the far right and should not be confused with the auth0 signup on the left (don't use that one, that is what I did and wasted an hour of my time, don't be like me...).

![](images/signup-developer-edition.png)

You will need a company email address, but in my case I was able to use an alias in `tstraub+oktaadmin@hashicorp.com` as the Okta Admin user. This user will only be used to configure Okta, not to access TFE.

Once you sign up, you should have access to domain in the format of "https://dev-[Some Random Numbers]-admin.okta.com", this will be your Okta Portal.

### Configure Okta

There are a few things we want to do in order to make our lives easier, as well as required steps to get credentials for TFE to work.

#### Update Authenticators

By default, the users we will create must enrol in Okta Verify. This is too much work, let's change this.

In the Okta Portal navigate to Security -> Authenticators.

![](images/okta-authenticators.png)

On the "Email" row, select Actions -> Edit.
Update the "Used for" to "Authentication and Recovery" to enable the use of email verification when logging in.
Click Save.

![](images/okta-authenticator-email.png)

#### Add Custom User Attribute

In order for Site Admin to work with SAML attributes, we need a boolean to indicate these users.

In the Okta Portal navigate to Directory -> Profile Editor.

![](images/okta-profile-editor.png)

Find the "User (default)" Profile and click on it.

![](images/okta-profile-editor-user.png)

On the left, click "+ Add Attribute" and set the following:

* Data Type: boolean
* Display Name: TFESiteAdmin
* Variable Name: TFESiteAdmin
* Description: TFESiteAdmin
* Read Only: Checked

Click save.

You should see the new attribute in the "Custom" panel.

![](images/okta-profile-custom-attribute.png)

### Create API Application

In order to get credentials for Terraform to communicate with Okta, we must create an API Application.

Details can be found [here](https://developer.okta.com/docs/guides/terraform-enable-org-access/main/), but essentially you will create an "API Services" Application for use with Terraform. You can call the application "Terraform API Access".

Once created, we need to update permissions by navigating to Applications -> Applications and selecting "Terraform API Access". 

In the "Okta API Scopes", click "Grant" on the following:

* okta.apps.manage
* okta.brands.manage
* okta.policies.manage
* okta.enduser.manage
* okta.users.manage
* okta.groups.manage
* okta.schemas.manage

> Note: If you start to run into API rate limit issues, you can select "Application Rate Limits" -> "Edit" and allocate a larger % to all.

## References

- https://developer.okta.com/signup/
- https://developer.hashicorp.com/terraform/tutorials/enterprise/enable-sso-saml-tfe-okta
