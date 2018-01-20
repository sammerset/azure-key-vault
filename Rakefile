require "bundler/gem_tasks"
require 'rake/testtask'
require 'rdoc/task'

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)

  task :default => :spec
rescue LoadError
  # no rspec available
end

RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc/rdocs'
  rdoc.main = "README.md"
  rdoc.rdoc_files.include("README.md", "lib")
end