require 'yandex/translator/version'
require 'httparty'
require 'yandex/translator'

module Yandex
  class TranslationError < StandardError; end
  class ApiError < StandardError; end
end
