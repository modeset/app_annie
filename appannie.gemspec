# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'app_annie/version'

Gem::Specification.new do |spec|
  spec.name          = "app_annie"
  spec.version       = AppAnnie::VERSION
  spec.authors       = ["Jay Zeschin"]
  spec.email         = ["jay.zeschin@modeset.com"]
  spec.description   = %q{Ruby wrapper for the AppAnnie API}
  spec.summary       = %q{A simple Ruby wrapper for AppAnnie's app store analytics API}
  spec.homepage      = "https://github.com/modeset/app_annie"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'faraday'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
end
