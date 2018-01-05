require 'spec_helper'
describe KeyVault::Client do
  let(:vault_name) {'the-vault'}
  let(:api_version) {KeyVault::DEFAULT_API_VERSION}
  let(:bearer_token) {'Bearer tokenvalue'}
  let(:client) {client = KeyVault::Client.new(vault_name, bearer_token)}

  it 'requires vault_name and bearer_token' do
    client = KeyVault::Client.new(vault_name, bearer_token)
    expect(client).not_to be_nil
  end

  it 'defaults api_version' do
    client = KeyVault::Client.new(vault_name, bearer_token)
    expect(client.api_version).to eq KeyVault::DEFAULT_API_VERSION
  end

  it 'allows setting of api_version' do
    client = KeyVault::Client.new(vault_name, bearer_token, api_version: '2015-06-01')
    expect(client.api_version).to eq '2015-06-01'
  end

  describe '.get_secret' do
    let(:secret_name) {'the-secret'}
    let(:secret_value) {'top secret'}
    let(:valid_response) {%Q[{
      "value": "#{secret_value}",
      "contentType": "String",
      "id": "https://#{vault_name}.vault.azure.net/secrets/#{secret_name}/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
      "attributes": {
        "enabled": true,
        "created": 1512680041,
        "updated": 1512680041,
        "recoveryLevel": "Purgeable"
      }
    }]}
    let(:rest_request) {
      class_double('RestClient')
        .as_stubbed_const(:transfer_nested_constants => true)
    }

    context 'get latest version of secret' do
      let(:secret_url) {"https://#{vault_name}.vault.azure.net/secrets/#{secret_name}?api-version=#{api_version}"}

      it 'should request GET from secret url' do
        expect(rest_request).to receive(:get)
          .with(secret_url,{:Authorization => bearer_token})
          .and_return(valid_response)
        client.get_secret secret_name
      end

      it 'should return secret value from response' do
        expect(rest_request).to receive(:get)
          .and_return(valid_response)
        returned_secret = client.get_secret secret_name
        expect(returned_secret).to eq secret_value
      end

      it 'should return nil if secret not found' do
        expect(rest_request).to receive(:get).and_raise(RestClient::NotFound)
        returned_secret = client.get_secret 'not-a-secret'
        expect(returned_secret).to be_nil
      end

      it 'should translate non alphanumerics and spaces to hyphens' do
        secret_key = 'a secret::with!#&$chars-and-1234567890'
        clean_secret_key = 'a-secret--with----chars-and-1234567890'
        clean_secret_url = "https://#{vault_name}.vault.azure.net/secrets/#{clean_secret_key}?api-version=#{api_version}"

        expect(rest_request).to receive(:get)
          .with(clean_secret_url,{:Authorization => bearer_token})
          .and_return(valid_response)
        client.get_secret secret_key
      end

    end

    context 'request version of secret' do
      let(:secret_version) {'abcdef'}
      let(:secret_url) {"https://#{vault_name}.vault.azure.net/secrets/#{secret_name}/#{secret_version}?api-version=#{api_version}"}
      
      it 'should request passed in version of secret' do
        expect(rest_request).to receive(:get)
          .with(secret_url,{:Authorization => bearer_token})
          .and_return(valid_response)
        client.get_secret(secret_name,secret_version)
      end
    end

  end
end