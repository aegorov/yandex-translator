require "yandex-translator/version"
require "httparty"

module Yandex::Translator
  include HTTParty
  base_uri 'https://translate.yandex.net/api/v1.5/tr.json'

  attr_accessor :api_key

  class TranslationError < StandardError; end
  class ApiError < StandardError; end

  def get_langs
    visit '/getLangs', key: api_key
  end

  def detect_lang(text)
    options = { text: text, key: api_key }
    visit '/detect', options
  end

  def translate(text, *lang)
    options = { text: text, lang: lang.join('-'), key: api_key }
    result =(visit '/translate', options)['text']
    result.size == 1 ? result.first : result
  end

  def visit(address, options = {})
    responce = get(address, query: options)
    check_errors(responce) unless responce.code == 200
    responce
  end

  def check_errors(responce)
    raise *(case responce.code
    when 401 then [ApiError, 'Invalid api key']
    when 402 then [ApiError, 'Api key blocked']
    when 403 then [ApiError, 'Daily request limit exceeded']
    when 404 then [ApiError, 'Daily char limit exceeded']
    when 413 then [TranslationError, 'Text too long']
    when 422 then [TranslationError, 'Can\'t translate text']
    when 501 then [TranslationError, 'Can\'t translate text in that direction']
    end)
  end

  extend Yandex::Translator
end
