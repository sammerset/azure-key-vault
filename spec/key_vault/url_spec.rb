require 'spec_helper'

describe KeyVault::Url do
  let(:key_vault_url) { KeyVault::Url.new('the_bearer_token', 'the_vault_name') }
  let(:correct_url) {'https://the_vault_name.vault.azure.net/secrets/the_secret_name/1234-1234-1234-1234?api-version=2015-08-20'}
  let(:correct_body) {{ "value" => 'the_secret_value'}.to_json}
  
  it 'gets the correct url' do 
    expect(key_vault_url.get_url('the_secret_name', '1234-1234-1234-1234', '2015-08-20')).to eq correct_url
  end
  
  it 'gets the correct body' do
    expect(key_vault_url.get_body('the_secret_value')).to eq correct_body    
  end

  context 'URL encoding' do
    let(:url) { KeyVault::Url.new('the_bearer_token', 'the vault name') }
    let(:encoded_url) {'https://the%20vault%20name.vault.azure.net/secrets/secret::key/1234-1234-1234-1234?api-version=2015-08-20'}
    it 'Encodes the url' do
      expect(url.get_url('secret::key','1234-1234-1234-1234', '2015-08-20')).to eq encoded_url
    end
  end
end
