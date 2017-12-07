require 'spec_helper'
describe KeyVault::Auth do
  let(:tenant_id) {'the-tenant-id'}
  let(:client_id) {'the-client-id'}
  let(:client_secret) {'the-client-secret'}

  it 'requires tenant_id, client_id and client_secret' do
    auth = KeyVault::Auth.new(tenant_id,client_id, client_secret)
    expect(auth).not_to be_nil
  end

  describe 'get_bearer_token' do
    let(:auth) {KeyVault::Auth.new(tenant_id,client_id, client_secret)}
    let(:auth_url) {"https://login.windows.net/#{tenant_id}/oauth2/token"}
    let(:access_token) {'theaccesstoken'}
    let(:auth_response) {%Q[{
      "token_type":"Bearer",
      "some_other_params":"...",
      "resource":"https://vault.azure.net",
      "access_token":"#{access_token}"
    }]}

    let(:rest_request) {
      class_double('RestClient::Request')
        .as_stubbed_const(:transfer_nested_constants => true)
    }      
    
    it 'should authenticate to microsoft rest api' do
      expect(rest_request).to receive(:execute).and_return(auth_response)
      auth.get_bearer_token
    end

    it 'should post credentials in the request payload' do
      auth_body_with_credentials = {
        "grant_type" => "client_credentials",
        "client_id" => client_id,
        "client_secret" => client_secret,
        "resource" => 'https://vault.azure.net'
      }      
      expect(rest_request).to receive(:execute)
         .with(hash_including(method: :post, payload: auth_body_with_credentials))
          .and_return(auth_response)
      auth.get_bearer_token
    end 

    it 'should return the access_token as bearer token' do
      expect(rest_request).to receive(:execute).and_return(auth_response)
      expect(auth.get_bearer_token).to eq("Bearer #{access_token}")
    end

  end



end