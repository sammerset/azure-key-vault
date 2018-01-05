require 'key_vault/auth'
require 'key_vault/url'
require 'key_vault/exceptions'
require 'key_vault/api_version'
require 'rest-client'
require 'json'

module KeyVault
  class Client
    
    attr_reader :api_version

    def initialize(vault_name, bearer_token, api_version: DEFAULT_API_VERSION)
      @vault_name = vault_name
      @api_version = api_version || DEFAULT_API_VERSION
      @bearer_token = bearer_token
      @vault_url = Url.new(@bearer_token, @vault_name)
    end
    
    def get_secret(secret_name, secret_version=nil)
      begin
        response = RestClient.get(@vault_url.get_url(secret_name, secret_version, @api_version), {:Authorization => @bearer_token})
        JSON.parse(response)['value']
      rescue RestClient::ResourceNotFound
        return nil
      end
    end
      
    def create_secret(secret_name, secret_value)
      RestClient.put(@vault_url.get_url(secret_name, nil, @api_version), @vault_url.get_body(secret_value), {"Content-Type" => "application/json", "Authorization" => @bearer_token})
    end
  end
end