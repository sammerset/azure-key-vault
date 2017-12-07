require 'rake/testtask'

task :default do
  puts "TBD: https://github.com/jsok/hiera-vault/issues/17"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end