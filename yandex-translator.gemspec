# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yandex/translator/version'

Gem::Specification.new do |gem|
  gem.name          = "yandex-translator"
  gem.version       = Yandex::Translator::VERSION
  gem.authors       = ["Artur Egorov"]
  gem.email         = ["artur@egorov.in"]
  gem.description   = %q{Library for Yandex Translate API}
  gem.summary       = %q{Yandex Translate API}
  gem.homepage      = ""

  gem.add_dependency 'httparty', '>= 0.13.4'
  gem.add_development_dependency 'rspec', '~> 3.1'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'vcr'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
