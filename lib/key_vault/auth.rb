require 'rest-client'
require 'json'
module KeyVault
  # Authenticater for Azure Key Vault
  class Auth
    # Create authenticator using Azure principal
    # ==== Parameters:
    # +tenant_id+:: Azure tenant id
    # +client_id+:: Azure client id or (key)
    # +client_secret+:: Azure client secret
    def initialize(tenant_id, client_id, client_secret)
      @tenant_id = tenant_id
      @client_id = client_id
      @client_secret = client_secret
    end

    # Authenticates with Azure using OAUTH 2.0
    # ==== Returns:
    # A string containing the bearer token for insertion into request headers
    # ==== Raises:
    # +ArgumentError+:: If the authentication request format is invalid
    # +KeyVault::Unauthorized+:: If authentication fails authorization
    def bearer_token
      result = RestClient::Request.execute(method: :post,
                                           url: url,
                                           payload: body,
                                           headers: headers)
      token_resp = JSON.parse(result)
      "Bearer #{token_resp['access_token']}"
    rescue RestClient::BadRequest
      raise ArgumentError, 'Could not authenticate to Azure (Bad Request)'
    rescue RestClient::Unauthorized
      raise KeyVault::Unauthorized
    end

    private

    def headers
      { 'Content-Type' => 'application/x-www-form-urlencoded' }
    end

    def url
      "https://login.windows.net/#{@tenant_id}/oauth2/token"
    end

    def body
      { 'grant_type' => 'client_credentials',
        'client_id' => @client_id,
        'client_secret' => @client_secret,
        'resource' => 'https://vault.azure.net' }
    end
  end
end
