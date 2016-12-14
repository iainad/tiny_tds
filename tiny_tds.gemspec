# -*- encoding: utf-8 -*-
$LOAD_PATH.push File.expand_path('../lib', __FILE__)
require 'tiny_tds/version'

Gem::Specification.new do |s|
  s.name          = 'tiny_tds_coderjoe'
  s.version       = TinyTds::VERSION
  s.platform      = Gem::Platform::RUBY
  s.authors       = ['Joseph Bauser', 'Ken Collins', 'Erik Bryn', 'Will Bond']
  s.email         = ['coderjoe@coderjoe.net', 'ken@metaskills.net', 'will@wbond.net']
  s.homepage      = 'http://github.com/coderjoe/tiny_tds/tree/coderjoe.gem'
  s.summary       = 'A testing version of the tiny_tds gem DO NOT USE'
  s.description   = 'A testing version of the tiny_tds gem DO NOT USE. This is guaranteed to disappear in the future.'
  s.files         = `git ls-files`.split("\n") + Dir.glob('exe/*')
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
  s.rdoc_options  = ['--charset=UTF-8']
  s.extensions    = ['ext/tiny_tds/extconf.rb']
  s.license       = 'MIT'
  s.required_ruby_version = '>= 2.0.0'
  s.add_runtime_dependency     'mini_portile2', '~> 2.0' # Keep this version in sync with the one in extconf.rb !
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'rake-compiler', '0.9.5'
  s.add_development_dependency 'rake-compiler-dock', '~> 0.5.1'
  s.add_development_dependency 'minitest', '~> 5.6'
  s.add_development_dependency 'connection_pool', '~> 2.2'
end
