# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'micro_kanren/version'

Gem::Specification.new do |spec|
  spec.name          = "micro_kanren"
  spec.version       = MicroKanren::VERSION
  spec.authors       = ["Justin Leitgeb"]
  spec.email         = ["justin@stackbuilders.com"]
  spec.summary       = %q{uKanren in Ruby}
  spec.description   = %q{A port of uKanren to Ruby.}
  spec.homepage      = "http://github.com/jsl/ruby_ukanren"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'mocha'
end
