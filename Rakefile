
begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

task :default => 'test:run'
task 'gem:release' => 'test:run'

Bones {
  name     'bbcoder'
  authors  'John "asceth" Long'
  email    'machinist@asceth.com'
  url      'http://github.com/asceth/bbcoder'
}

