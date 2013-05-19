# encoding: UTF-8

require "yandex-translator/version"
require "httparty"

module Yandex
  module Translator

    class TranslationError < StandardError; end
    class ApiError < StandardError; end

    class Translation
      include HTTParty
      base_uri 'https://translate.yandex.net/api/v1.5/tr'


      def self.api_key=(key)
        @@api_key = key
      end

      def detect_lang(text)
        options = {}
        options[:query] = { :text => text, :key => @@api_key }
        language = self.class.get("/detect", options)
        if language["DetectedLang"]
          language["DetectedLang"]["lang"]
        else
          check_api_errors(language)
        end
      end

      def translate(text, to_language, from_language)
        lang = from_language.nil? ? to_language : "#{from_language}-#{to_language}"
        options = {}
        options[:query] = { :lang => lang, :text => text, :key => @@api_key }
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
            check_api_errors(translation)
        end
      end

      private

      def check_api_errors(responce)
        case responce["Translation"]["code"].to_i
          when 401
            ApiError.new("Invalid api key")
          when 402
            ApiError.new("Api key blocked")
          when 403
            ApiError.new("Daily request limit exceeded")
          when 404
            ApiError.new("Daily char limit exceeded")
          else
            raise TranslationError.new("Try again later")
        end
      end

    end

    def self.set_api_key(key)
      Translation.api_key = key
    end

    def self.detect(text = '')
      Translation.new.detect_lang(text)
    end

    def self.translate(text, to_language, from_language = nil)
      Translation.new.translate(text, to_language, from_language)
    end

  end
end
