# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiera/backend/eyaml/encryptors/kms'

Gem::Specification.new do |gem|
  gem.name          = "hiera-eyaml-kms-role"
  gem.version       = Hiera::Backend::Eyaml::Encryptors::Kms::VERSION
  gem.description   = "AWS KMS encryptor for use with hiera-eyaml with added assume IAM role based on https://github.com/adenot/hiera-eyaml-kms"
  gem.summary       = "KMS Encryption plugin for hiera-eyaml backend for Hiera"
  gem.author        = "Chris Horder"
  gem.license       = "MIT"

  gem.homepage      = "https://github.com/3HGroup/hiera-eyaml-kms-role"
  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
