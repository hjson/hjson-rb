# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hjson/version'

Gem::Specification.new do |spec|
  spec.name          = 'hjson'
  spec.version       = Hjson::VERSION
  spec.authors       = ['namusyaka']
  spec.email         = ['namusyaka@gmail.com']

  spec.summary       = %q{Human JSON (Hjson) implementation for Ruby}
  spec.description   = %q{Human JSON (Hjson) implementation for Ruby}
  spec.homepage      = 'https://github.com/namusyaka/hjson'
  spec.license       = 'MIT'

  spec.required_ruby_version = '>= 3.0.0'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'json', '>= 2.6.0'
  spec.add_development_dependency 'hashdiff'
  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'test-unit'
end
