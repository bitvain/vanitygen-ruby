require 'bundler/gem_tasks'
require 'rake/extensiontask'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

Rake::ExtensionTask.new 'vanitygen' do |ext|
  ext.name = 'vanitygen_ext'
  ext.lib_dir = 'lib/vanitygen'
end

task :default => [:compile, :spec]
