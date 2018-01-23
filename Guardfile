## Uncomment and set this to only include directories you want to watch
# directories %w(lib config test spec features) \
#   .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}
interactor :off

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})    { |m| "spec/#{m[1]}_spec.rb" }
end

guard :rdoc, main: 'README.md' do
  #watch('README.md')
  watch(%r{^README.md|lib/.+\.rb$}) { |m | ['lib', 'README.md'] }
end 

guard :bundler do
  watch('Gemfile')
  watch(%r{^(.+\.gemspec)$})
end
