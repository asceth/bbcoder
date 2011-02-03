require 'rubygems'
require 'bundler'
Bundler.setup

require 'bbcoder'

RSpec.configure do |config|
  config.mock_with :rr
end

