$:.push File.expand_path("../lib", __FILE__)
require "bbcoder/version"

Gem::Specification.new do |s|
  s.name        = "bbcoder"
  s.version     = BBCoder::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["John 'asceth' Long"]
  s.email       = ["machinist@asceth.com"]
  s.homepage    = "http://github.com/asceth/bbcoder"
  s.summary     = "BBCode parser"
  s.description = "A gem for parsing bbcode that doesn't rely on regular expressions"

  s.rubyforge_project = "bbcoder"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_bundler_dependencies
end

