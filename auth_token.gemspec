require File.expand_path("../lib/auth_token/version", __FILE__)

Gem::Specification.new do |spec|
  spec.name                  = "auth_token"
  spec.version               = AuthToken::VERSION
  spec.license               = "MIT"
  spec.homepage              = "https://github.com/hopsoft/auth_token"
  spec.summary               = "A simple auth token storage engine"
  spec.description           = "A simple auth token storage engine"

  spec.authors               = ["Nathan Hopkins"]
  spec.email                 = ["natehop@gmail.com"]

  spec.required_ruby_version = ">= 2.0.0"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "micro_test", "~> 0.4.0"

  spec.files = Dir["lib/**/*.rb", "[A-Z].*"]
  spec.test_files = Dir["test/**/*.rb"]
end

