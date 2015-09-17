require "bundler/gem_tasks"
require "rspec/core/rake_task"

if RUBY_VERSION.to_i < 2
  exclude = 'spec/func_kwargs_spec.rb'
end

RSpec::Core::RakeTask.new(:spec) do |config|
  config.exclude_pattern = exclude
end

task :default => :spec
