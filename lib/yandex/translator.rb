module Yandex
  class Translator
    include HTTParty
    base_uri 'https://translate.yandex.net/api/v1.5/tr.json'

    attr_reader :api_key


    def initialize(api_key)
      @api_key = api_key
    end

    def langs
      @langs ||= visit('/getLangs')['dirs']
    end
    alias_method :get_langs, :langs

    def detect(text)
      visit('/detect', text: text)['lang']
    end

    def translate(text, *lang)
      if lang.last.is_a?(Hash)
        lang_options = lang.last
        lang = [lang_options[:to], lang_options[:from]].compact
      end

      options = { text: text, lang: lang.reverse.join('-') }

      result = visit('/translate', options)['text']

      result.size == 1 ? result.first : result
    end

    def visit(address, options = {})
      response = self.class.post address, body: options.merge(key: api_key)
      check_errors(response)
      response
    end

    private

    def check_errors(response)
      return if response['code'].to_i == 200
      fail ApiError, response['message']
    end
  end
end
