module Yandex
  class Translator
    include HTTParty
    base_uri 'https://translate.yandex.net/api/v1.5/tr.json'

    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def get_langs
      @get_langs ||= visit('/getLangs')['dirs']
    end

    def detect(text)
      visit('/detect', text: text)['lang']
    end

    def translate(text, *lang)
      options = { text: text, lang: lang.reverse.join('-') }
      result = visit('/translate', options)['text']
      result.size == 1 ? result.first : result
    end

    def visit(address, options = {})
      responce = self.class.post address, body: options.merge(key: api_key)
      check_errors(responce)
      responce
    end

    private

    def check_errors(response)
      error = error_by_code(response.code)
      fail error if error.present?
    end

    def error_by_code(code)
      case code
      when 401 then ApiError.new('Invalid api key')
      when 402 then ApiError.new('Api key blocked')
      when 403 then ApiError.new('Daily request limit exceeded')
      when 404 then ApiError.new('Daily char limit exceeded')
      when 413 then TranslationError.new('Text too long')
      when 422 then TranslationError.new('Can\'t translate text')
      when 501 then TranslationError.new('Can\'t translate text in that direction')
      else
        nil
      end
    end

  end
end
