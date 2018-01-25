require 'spec_helper'

describe KeyVault::Url do
  subject(:key_vault_url) { KeyVault::Url.new('the-vault-name') }

  describe '#new' do
    it 'requires a vault name' do
      key_vault_url = KeyVault::Url.new('a-vault-name')
      expect(key_vault_url).not_to be_nil
    end
  end

  describe '.get_url' do
    let(:secret_name) { 'the-secret-name' }
    let(:secret_version) { '1234-1234-1234-1234' }
    let(:api_version) { '2015-08-20' }
    let(:correct_url) { "https://the-vault-name.vault.azure.net/secrets/#{secret_name}/#{secret_version}?api-version=#{api_version}" }

    it 'gets url containing the vault and secret names' do
      expect(key_vault_url.get_url(secret_name, secret_version, api_version))
        .to eq correct_url
    end

    context 'when names in the URL need escaping' do
      let(:url) { KeyVault::Url.new('the vault name') }
      let(:encoded_url) { "https://the+vault+name.vault.azure.net/secrets/secret%3A%3Akey/#{secret_version}?api-version=#{api_version}" }
      it 'URL encodes the URL' do
        expect(url.get_url('secret::key', secret_version, api_version))
          .to eq encoded_url
      end
    end
  end

  describe '.get_body' do
    let(:correct_body) { { 'value' => 'the_secret_value' }.to_json }
    it 'gets the secret value as json' do
      expect(key_vault_url.get_body('the_secret_value')).to eq correct_body
    end
  end
end
