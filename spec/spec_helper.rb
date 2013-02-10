require 'rspec'
require 'yandex-translator'
require 'webmock/rspec'
include WebMock

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
end