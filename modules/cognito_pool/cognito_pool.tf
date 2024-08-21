resource "aws_cognito_user_pool" "main" {
  name = var.userpool_name

  username_configuration {
    case_sensitive = false
  }

  admin_create_user_config {
    allow_admin_create_user_only = var.disable_public_signup
  }

  account_recovery_setting {
    recovery_mechanism {
      name     = "admin_only"
      priority = 1
    }
  }

  auto_verified_attributes = ["email"]

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "email"
    required            = true
  }

  schema {
    attribute_data_type = "String"
    mutable             = true
    name                = "name"
    required            = true
  }

  schema { 
    attribute_data_type      = "String"
    mutable                  = true
    name                     = "saml_groups"
    required                 = false

    string_attribute_constraints {
      min_length = 0
      max_length = 2048
    }
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }
}

resource "aws_acm_certificate" "cognito_ssl_cert" {
  private_key       = file(var.ssl_certificate_private_key_path)
  certificate_body  = file(var.ssl_certificate_body_path)
  certificate_chain = file(var.ssl_certificate_chain_path)

  tags = {
    Name = "Cognito Wildcard Certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

#resource "aws_cognito_user_pool_domain" "main" {
#  domain          = var.cognito_domain
#  certificate_arn = aws_acm_certificate.cognito_ssl_cert.arn
#  user_pool_id    = aws_cognito_user_pool.main.id
#}

resource "aws_cognito_user_pool_client" "main" {
  name = var.userpool_name

  user_pool_id                         = aws_cognito_user_pool.main.id
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  callback_urls                        = var.callback_urls
  logout_urls                          = var.logout_urls
  access_token_validity                = 24
  id_token_validity                    = 12
  refresh_token_validity               = 1
  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }
  
  explicit_auth_flows = var.disable_public_signup ? ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"] : ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]

  prevent_user_existence_errors = "ENABLED"
  
  supported_identity_providers = var.use_saml_idp ? [aws_cognito_identity_provider.saml[0].provider_name] : ["COGNITO"]
}

resource "aws_cognito_identity_provider" "saml" {
  count = var.use_saml_idp ? 1 : 0

  user_pool_id  = aws_cognito_user_pool.main.id
  provider_name = var.provider_name
  provider_type = "SAML"

  attribute_mapping = {
    email       = "E-Mail Address"
    name        = "Name"
    given_name  = "Given Name"
    family_name = "Surname"
    "custom:saml_groups" = "groups"
  }

  provider_details = {
    MetadataURL = var.sp_metadata_url
  }
}