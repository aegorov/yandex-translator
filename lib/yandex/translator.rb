
module Yandex

  class JsonParser < HTTParty::Parser
    def json
      ::JSON.parse(body)
    end
  end

  class Translator
    include HTTParty
    parser JsonParser
    base_uri 'https://translate.yandex.net/api/v1.5/tr.json'

    attr_reader :api_key

    class << self # backwards compatability
      attr_reader :api_key, :translator

      def api_key=(key)
        @api_key = key
        @translator = new(api_key)
      end

      def get_langs
        translator.get_langs
      end

      def translate(text, from: nil, to: nil)
        translator.translate(text, from: from, to: to)
      end

      def detect(text)
        translator.detect(text)
      end

      private :translator
    end

    def initialize(api_key)
      @api_key = api_key
    end

    def langs
      @langs ||= visit('/getLangs')['dirs']
    end
    alias_method :get_langs, :langs

    def detect(text)
      lang = visit('/detect', text: text)['lang']
      lang == '' ? nil : lang
    end

    def translate(text, from: nil, to: nil, format: 'plain')
      lang = (to.nil? && from.nil?) ? [] : [to, from].compact

      options = { text: text, lang: lang.reverse.join('-'), format: format }

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
      if response['code'] and response['code'].to_i != 200
        fail ApiError, response['message']
      end
    end
  end
end
