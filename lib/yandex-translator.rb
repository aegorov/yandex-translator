# encoding: UTF-8

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

      def translate(text, to_language, from_language)
        lang = from_language.nil? ? to_language : "#{from_language}-#{to_language}"
        options = {}
        options[:query] = { :lang => lang, :text => text }
        translation = self.class.get("/translate", options)
        raise TranslationError.new("Can't translate text to #{to_language}") if translation["Translation"].nil?
        case translation["Translation"]["code"].to_i
          when 200
            translation["Translation"]["text"]
          when 413
            raise TranslationError.new("Text too long")
          when 422
            raise TranslationError.new("Can't translate text")
          when 501
            raise TranslationError.new("Can't translate text to #{to_language}")
          else
            raise TranslationError.new("Try again later")
        end
      end

    end

    def self.detect(text = '')
      Translation.new.detect_lang(text)
    end

    def self.translate(text, to_language, from_language = nil)
      Translation.new.translate(text, to_language, from_language)
    end

  end
end
