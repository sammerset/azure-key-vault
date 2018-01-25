module KeyVault
  # Helper for Key Vault URL's and REST document bodies
  # :category: Internal
  class Url
    # Creates URL for keyvault from +bearer_token+ and +vault_name+
    def initialize(vault_name)
      @vault_name = vault_name
    end

    # Gets URL for the secret
    def get_url(secret_name, version, api_version)
      base_url = format(base_secret_url,
                        vault_name: CGI.escape(@vault_name),
                        secret_name: CGI.escape(secret_name))
      base_url << "/#{version}" if version
      base_url << get_api_version_string(api_version)
      base_url
    end

    # Returns +secret_value+ as a json doc
    def get_body(secret_value)
      { 'value' => secret_value }.to_json
    end

    private

    # Returns url for the key vault
    def base_secret_url
      'https://%<vault_name>s.vault.azure.net/secrets/%<secret_name>s'
    end

    # Returns api_version url parameter
    def get_api_version_string(api_version)
      "?api-version=#{api_version}"
    end
  end
end
