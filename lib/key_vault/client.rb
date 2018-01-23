require 'key_vault/auth'
require 'key_vault/url'
require 'key_vault/exceptions'
require 'rest-client'
require 'json'

module KeyVault

  # Client for Azure Key Vault
  #
  # Allows creation and retrieval of secrets from Azure Key Vault
  #  
  # *N.B.* Secret names can contain only contain alphanumerics or hyphens.
  # Any 'invalid' characters will be translated into hyphens.
  class Client
    # version of the Azure REST API being used
    attr_reader :api_version

    # Create client for a key vault
    # 
    # ==== Parameters:
    # +vault_name+:: The name of the key vault
    # +bearer_token+:: The authentication credentials obtained by by +KeyVault::Auth+
    # +api_version+:: (*optional*) Version of the azure REST API to use. 
    #                 Defaults to +DEFAULT_API_VERSION+
    def initialize(vault_name, bearer_token, api_version: DEFAULT_API_VERSION)
      @vault_name = vault_name
      @api_version = api_version || DEFAULT_API_VERSION
      @bearer_token = bearer_token
      @vault_url = Url.new(@bearer_token, @vault_name)
    end
    
    # Retrieves secret from key vault as a string
    #
    # ==== Parameters:
    # +secret_name+:: Name of the secret (alphanumeric with hyphens)
    # +secret_version+:: (*optional*) Version of the secret to retrieve.  
    #                    Defaults to latest version  
    # ==== Returns:
    # A string containing the secret value or nil if not found
    def get_secret(secret_name, secret_version=nil)
      clean_name = secret_name.gsub /[^a-zA-Z0-9-]/, '-'
      begin
        response = RestClient.get(@vault_url.get_url(clean_name, secret_version, @api_version), {:Authorization => @bearer_token})
        JSON.parse(response)['value']
      rescue RestClient::NotFound
        return nil
      end
    end
    
    # Adds a secret to key vault
    #
    # ==== Parameters:
    # +secret_name+:: Name of the secret (alphanumeric with hyphens)
    # +secret_value+:: Value of the secret as a string
    def create_secret(secret_name, secret_value)
      clean_name = secret_name.gsub /[^a-zA-Z0-9-]/, '-'
      RestClient.put(@vault_url.get_url(secret_name, nil, @api_version), @vault_url.get_body(secret_value), {"Content-Type" => "application/json", "Authorization" => @bearer_token})
    end
  end
end