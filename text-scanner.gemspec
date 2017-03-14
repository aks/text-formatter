# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'text/scanner/version'

Gem::Specification.new do |spec|
  spec.name          = "text-scanner"
  spec.version       = Text::Scanner::VERSION
  spec.authors       = ["Alan Stebbens"]
  spec.email         = ["aks@stebbens.org"]

  spec.summary       = %q{A simple text scanner}
  spec.description   = %q{A library to make writing text scanners easier.}
  spec.homepage      = "https://github.com/aks/scanner"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "guard", "~> 2.14.1"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rspec", "~> 3.5.0"
  spec.add_development_dependency "ruby_gntp", "~> 0.3.4"
  spec.add_runtime_dependency "activesupport"
end
