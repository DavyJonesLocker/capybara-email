require 'bundler/setup'
require 'rspec/core/rake_task'
Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new('default') do |t|
  t.pattern = FileList['spec/**/*_spec.rb']
end

