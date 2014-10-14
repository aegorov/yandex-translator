require 'spec_helper'

describe Yandex::Translator do
  let(:api_key) { 'secret' }

  subject(:translator) { Yandex::Translator.new(api_key) }

  describe '#translate' do
    let(:translate_url) { 'https://translate.yandex.net/api/v1.5/tr.json/translate' }
    let(:translate_request_body) { "text=Car&lang=ru&key=#{api_key}" }
    let(:translate_response_body) do
      '<?xml version="1.0" encoding="UTF-8"?>
      <Translation code="200" lang="en-ru"><text>Автомобиль</text></Translation>'
    end

    let!(:translate_request) do
      stub_request(:post, translate_url)
        .with(body: translate_request_body)
        .to_return(body: translate_response_body)
    end

    it 'triggers correct yandex translation url' do
      translator.translate('Car', 'ru')
      expect(translate_request).to have_been_made.once
    end

    it 'returns translalation' do
      expect(translator.translate('Car', 'ru')).to eq 'Автомобиль'
    end

    it 'accepts options' do
      translator.translate('Car', from: :ru)
      expect(translate_request).to have_been_made.once
    end

    context 'with two languages' do
      let(:translate_request_body) { "text=Car&lang=ru-en&key=#{api_key}" }

      it 'accepts options' do
        translator.translate('Car', from: :ru, to: :en)
        expect(translate_request).to have_been_made.once
      end

      it 'accepts languages list' do
        translator.translate('Car', :ru, :en)
        expect(:translate_request).to have_been_made.once
      end
    end

    context 'when server responds with invalid "lang" parameter error' do
      let(:translation_url) { "https://translate.yandex.net/api/v1.5/tr/translate?key=#{api_key}&lang=ru-ru&text=Car" }
      let(:translate_response_body) { 'TrService1: Invalid parameter \'lang\'' }

      it 'returns translation error' do
        expect{
          translator.translate('Car', 'ru', 'ru')
        }.to raise_error(Yandex::TranslationError, "Can't translate text to ru")
      end
    end
  end

  describe '#detect' do
    let(:detect_url) { "https://translate.yandex.net/api/v1.5/tr/detect?key=#{api_key}&text=Car" }
    let(:decect_response_body) { '<?xml version="1.0" encoding="utf-8"?><DetectedLang code="200" lang="en"/>' }
    let!(:detect_request) { stub_request(:post, detect_url).to_return(body: decect_response_body) }

    it 'hits correct url' do
      translator.detect('Car')
      expect(detect_request).to have_been_made.once
    end

    it 'returns detected language' do
      expect(translator.detect('Car')).to eq 'ru'
    end

    context 'when response does not contains any language' do
      let(:decect_response_body) { '<?xml version="1.0" encoding="utf-8"?><DetectedLang code="200" lang=""/>' }

      it 'returns nil' do
        expect(translator.detect('Car')).to be_nil
      end
    end
  end
end
