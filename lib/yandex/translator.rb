module Yandex
  class Translator
    ERROR_BY_CODE = {
      401 => 'Invalid api key', 402 => 'Api key blocked', 403 => 'Daily request limit exceeded',
      404 => 'Daily char limit exceeded', 413 => 'Daily char limit exceeded',
      422 => 'Can\'t translate text', 501 => 'Can\'t translate text in that direction'
    }

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
      if lang.last.is_a?(Hash)
        lang_options = lang.last
        lang = [lang_options[:from], lang_options[:to]].compact
      end

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
      return if response.code == 200
      error = error_by_code(response.code)
      fail error if error
    end

    def error_by_code(code)
      error_class = Yandex::ApiError
      error_class = Yandex::TranslationError unless 401 <= code && code <= 404

      error_text = ERROR_BY_CODE[code] || 'Unknown error'

      fail error_class, error_text
    end

  end
end
