# infra/entra_id.tf

resource "azuread_application" "archie_app" {
  display_name = "archie-${var.environment}" # e.g., archie-dev
  tags         = ["terraform", "archie", var.environment] # Add relevant tags for Entra ID

  # Assign the deploying principal (GitHub Actions OIDC SP) as an owner
  # Ensure var.az_object_id contains the Object ID of the SP used by azure/login
  owners = [var.az_object_id]

  # Configure for Single Page Application (SPA) using Auth Code Flow with PKCE
  spa {
    # Redirect URIs need the default hostname of the Static Web App
    # Ensure 'archie_swa' matches the name of your azurerm_static_web_app resource
    # This creates an implicit dependency on the SWA being defined first or in the same plan
    redirect_uris = ["https://${azurerm_static_web_app.archie_swa.default_host_name}/.auth/login/aad/callback"]
  }

  # Optional: Define API permissions if Archie backend needs to call Graph API or ADOIT API (if secured by Entra ID)
  # required_resource_access {
  #   resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
  #
  #   resource_access {
  #     id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d" # User.Read (Example Scope)
  #     type = "Scope"
  #   }
  #   # Add other permissions as needed (e.g., for ADOIT API)
  # }

  # Optional: If Archie backend exposes its own API that other apps might call
  # identifier_uris = ["api://archie-${var.environment}"]
  # api {
  #   oauth2_permission_scope {
  #     admin_consent_description  = "Allow the application to access Archie backend on behalf of the signed-in user."
  #     admin_consent_display_name = "Access Archie backend"
  #     id                         = random_uuid.api_scope_id.result # Generate a unique ID
  #     type                       = "User"
  #     user_consent_description   = "Allow the application to access Archie backend on your behalf."
  #     user_consent_display_name  = "Access Archie backend"
  #     value                      = "Archie.Access" # The scope name
  #   }
  # }
}

# Required: Create the Service Principal for the Application Registration
resource "azuread_service_principal" "archie_sp" {
  application_id = azuread_application.archie_app.application_id
  owners         = [var.az_object_id] # Assign owner
  tags           = ["terraform", "archie", var.environment]
  # app_role_assignment_required = false # Default is false. Set true if you only want explicitly assigned users/groups to sign in.
}

# --- Optional: If your backend Function App needs its OWN secret ---
# --- (Often not needed if using delegated user permissions passed from frontend) ---
# resource "azuread_application_password" "archie_app_secret" {
#   application_id = azuread_application.archie_app.id
#   display_name   = "TerraformManagedSecret-${var.environment}"
#   # end_date_relative = "8760h" # 1 year validity - adjust as needed
# }

# --- Store the secret in Key Vault if generated ---
# resource "azurerm_key_vault_secret" "archie_client_secret" {
#   # Ensure 'archie_kv' matches the name of your azurerm_key_vault resource
#   key_vault_id = azurerm_key_vault.archie_kv.id
#   name         = "archie-client-secret-${var.environment}"
#   value        = azuread_application_password.archie_app_secret.value
#
#   tags = var.tags
#
#   depends_on = [
#     # Ensure KV access policy for Terraform SP is applied first if needed
#     # Or ensure KV exists
#     azurerm_key_vault.archie_kv
#   ]
# }
# --- End Optional Secret Section ---

# Output the Application (Client) ID - useful for configuring other resources
output "archie_application_client_id" {
  value       = azuread_application.archie_app.application_id
  description = "The Application (Client) ID for the Archie Entra ID application."
}

# Optional: Output the Service Principal ID
output "archie_service_principal_id" {
  value       = azuread_service_principal.archie_sp.id
  description = "The Object ID for the Archie Service Principal."
}

# Optional: Output the Tenant ID (though it's usually known)
output "archie_tenant_id" {
  value       = azuread_application.archie_app.tenant_id
  description = "The Tenant ID where Archie application is registered."
}

# Needed if generating API scopes
# resource "random_uuid" "api_scope_id" {}
