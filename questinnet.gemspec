# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'questinnet/version'

Gem::Specification.new do |spec|
  spec.name          = "questinnet"
  spec.version       = Questinnet::VERSION
  spec.authors       = ["kham"]
  spec.email         = ["piotrek@zonar.pl"]
  spec.description   = 'Description'
  spec.summary       = 'summary'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "nori", '~> 2'
  spec.add_development_dependency 'testftpd', '~> 0.2', ['>= 0.2.1']
end
