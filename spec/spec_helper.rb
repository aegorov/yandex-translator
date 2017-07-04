require 'rspec'
require 'yandex-translator'
require 'webmock/rspec'
require 'vcr'
include WebMock::API

RSpec.configure do |config|
  if File.exists? ('spec/secrets.yml')
    YANDEX_API_KEY = YAML.load_file('spec/secrets.yml')
  else
    YANDEX_API_KEY = {}
  end
  config.add_setting :yandex_api_key, :default => YANDEX_API_KEY['yandex_translator_api_key']
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr'
  c.hook_into :webmock
  c.filter_sensitive_data('<YANDEX_API_KEY>') { RSpec.configuration.yandex_api_key }
end
