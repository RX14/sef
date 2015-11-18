# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "sef/version"

Gem::Specification.new do |spec|
  spec.name          = "sef"
  spec.version       = SEF::VERSION
  spec.authors       = ["RX14"]
  spec.email         = ["chris@rx14.co.uk"]

  spec.summary       = "A simple event framework with a flexible data model."
  spec.homepage      = "https://github.com/RX14/sef"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "concurrent-ruby", "~> 1.0.0"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_development_dependency "rubocop", "~> 0.35.0"

  spec.add_development_dependency "pry", "~> 0.10.3"
  spec.add_development_dependency "pry-coolline", "~> 0.2.5"
  spec.add_development_dependency "pry-doc", "~> 0.8.0"
  spec.add_development_dependency "pry-byebug", "~> 3.3.0"
end
