# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wpcli/version'

Gem::Specification.new do |spec|
  spec.name          = "wpcli"
  spec.version       = Wpcli::VERSION
  spec.authors       = ["Joni Hasanen"]
  spec.email         = ["joni.hasanen@pieceofcode.net"]
  spec.description   = %q{Simple wrapper for wp-cli (http://wp-cli.org/)}
  spec.summary       = %q{Simple wrapper for wp-cli (http://wp-cli.org/)}
  spec.homepage      = "http://hasanen.github.io/wpcli"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.1.0"
  spec.add_development_dependency "rspec", "~> 2.14.1"
end
