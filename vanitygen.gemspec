# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vanitygen/version'

Gem::Specification.new do |spec|
  spec.name          = "vanitygen"
  spec.version       = Vanitygen::VERSION
  spec.authors       = ["Benjamin Feng"]
  spec.email         = ["contact@fengb.info"]
  spec.summary       = %q{TODO: Write a short summary. Required.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "AGPL-3.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.extensions    = ['ext/vanitygen/extconf.rb']

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rake-compiler", "~> 0.9.3"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "bitcoin-ruby", "= 0.0.6"
  spec.add_development_dependency "ffi", "= 1.9.6"
end
