require "yandex-translator/version"
require "httparty"

module Yandex
  module Translator

    class TranslationError < StandardError
    end

    class Translation
      include HTTParty
      base_uri 'http://translate.yandex.net/api/v1/tr/'

      def detect_lang(text)
        options = {}
        options[:query] = { :text => text }
        language = self.class.get("/detect", options)
        language["DetectedLang"]["lang"]
      end

      def translate(text, language)
        options = {}
        options[:query] = { :lang => language, :text => text }
        translation = self.class.get("/translate", options)
        case translation["Translation"]["code"].to_i
          when 200
            translation["Translation"]["text"]
          when 413
            raise TranslationError.new("Text too long")
          when 422
            raise TranslationError.new("Can't translate text")
          when 501
            raise TranslationError.new("Can't translate to this language")
          else
            raise TranslationError.new("Try again later")
        end
      end

    end


    def self.detect(text = '')
      Translation.new.detect_lang(text)
    end

    def self.translate(text = '', language)
      Translation.new.translate(language, text)
    end

  end
end
