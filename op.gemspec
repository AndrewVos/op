# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'op/version'

Gem::Specification.new do |gem|
  gem.name          = "op"
  gem.version       = Op::VERSION
  gem.authors       = ["Andrew Vos"]
  gem.email         = ["andrew.vos@gmail.com"]
  gem.description   = %q{ERMAHGERD ARPTERN PERSING}
  gem.summary       = %q{ERMAHGERD ARPTERN PERSING}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "minitest"
end
