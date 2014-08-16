# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'headjack/version'

Gem::Specification.new do |spec|
  spec.name          = "headjack"
  spec.version       = Headjack::VERSION
  spec.authors       = ["Manuel Albarrán"]
  spec.email         = ["weap88@gmail.com"]
  spec.summary       = %q{A ruby connector for chypher and neo4j.}
  spec.description   = %q{A ruby connector for chypher and neo4j.}
  spec.homepage      = "https://github.com/weapp/headjack"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip", ">= 1.0.0"
  spec.add_dependency "os", ">= 0.9.6"
  spec.add_dependency "multi_json"
  spec.add_dependency "faraday"
  spec.add_dependency "faraday_middleware"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "3.0"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "coveralls"
  
  if /darwin|mac os/ === RbConfig::CONFIG['host_os']
    spec.add_development_dependency 'terminal-notifier-guard'
  end
end
