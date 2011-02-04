require "bundler"
Bundler.setup

require "rspec"
require "rspec/core/rake_task"

Rspec::Core::RakeTask.new(:spec)

gemspec = eval(File.read(File.join(Dir.pwd, "bbcoder.gemspec")))

task :build => "#{gemspec.full_name}.gem"

task :test => :spec

file "#{gemspec.full_name}.gem" => gemspec.files + ["bbcoder.gemspec"] do
  system "gem build bbcoder.gemspec"
  system "gem install bbcoder-#{BBCoder::VERSION}.gem"
end

