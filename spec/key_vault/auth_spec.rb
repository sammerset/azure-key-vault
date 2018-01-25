require 'spec_helper'
describe KeyVault::Auth do
  let(:tenant_id) {'the-tenant-id'}
  let(:client_id) {'the-client-id'}
  let(:client_secret) {'the-client-secret'}

  describe('#new') do
    it 'requires tenant_id, client_id and client_secret' do
      auth = KeyVault::Auth.new(tenant_id,client_id, client_secret)
      expect(auth).not_to be_nil
    end
  end

  describe '.bearer_token' do
    subject(:auth) { KeyVault::Auth.new(tenant_id,client_id, client_secret) }
    let(:auth_url) { "https://login.windows.net/#{tenant_id}/oauth2/token" }
    let(:access_token) { 'theaccesstoken' }
    let(:auth_response) { %Q[{
      "token_type":"Bearer",
      "some_other_params":"...",
      "resource":"https://vault.azure.net",
      "access_token":"#{access_token}"
    }] }

    let(:rest_request) do
      class_double('RestClient::Request')
        .as_stubbed_const(:transfer_nested_constants => true)
    end
    
    it 'authenticates with Microsoft OAUTH' do
      expect(rest_request).to receive(:execute).and_return(auth_response)
      auth.bearer_token
    end

    it 'raises argument error if bad request is returned' do
      expect(rest_request).to receive(:execute).and_raise(RestClient::BadRequest)
      expect{auth.bearer_token}.to raise_error(ArgumentError)
    end

    it 'raises custom Unauthorized exception if unauthorized' do
      expect(rest_request).to receive(:execute).and_raise(RestClient::Unauthorized)
      expect{auth.bearer_token}.to raise_error(KeyVault::Unauthorized)
    end

    it 'posts credentials in the request payload' do
      auth_body_with_credentials = {
        'grant_type'    => 'client_credentials',
        'client_id'     => client_id,
        'client_secret' => client_secret,
        'resource'      => 'https://vault.azure.net'
      }      
      expect(rest_request).to receive(:execute)
         .with(hash_including(method: :post, payload: auth_body_with_credentials))
          .and_return(auth_response)
      auth.bearer_token
    end 

    it 'returns the access_token as bearer token' do
      expect(rest_request).to receive(:execute).and_return(auth_response)
      expect(auth.bearer_token).to eq("Bearer #{access_token}")
    end

  end
end
