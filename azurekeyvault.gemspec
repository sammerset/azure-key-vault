# -*- mode: ruby; -*-
$LOAD_PATH.unshift 'lib'
require "key_vault/version"

Gem::Specification.new do |s|
  s.name      = "azure-key-vault"
  s.version   = KeyVault::VERSION.split(/[-+]/,2).first
  s.date      = Time.now.strftime('%Y-%m-%d')
  s.summary   = "Ruby Client for Azure Key Vault"
  s.homepage  = "http://bitbucket.com/hiscoxpsg/azure-key-vault"
  s.email     = "mike.scott2@hiscox.com"
  s.authors   = [ "Stuart Barr", "Mike Scott" ]
  s.has_rdoc  = false

  s.files = %x[git ls-files].split($/) - %w[.gitignore]
  s.require_paths = %w[lib]

  s.add_runtime_dependency 'json_pure',  '~>2.1'
  s.add_runtime_dependency 'rest-client', '~>2.0' 

  s.add_development_dependency "bundler", "~> 1.12"
  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "rspec", "~> 3.0"
end
