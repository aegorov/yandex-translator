require 'spec_helper'
require 'vcr'

describe Yandex::Translator do
  let(:api_key) { RSpec.configuration.yandex_api_key }
  subject(:translator) { Yandex::Translator.new(api_key) }

  describe '::translate' do
    before do
      expect_any_instance_of(Yandex::Translator).to receive(:translate)
      Yandex::Translator.api_key = api_key
    end
  end

  describe '#translate' do
    it 'returns ru translalation ' do
      VCR.use_cassette('get_translated_ru_text') do
        response = translator.translate('Car', 'ru')
        expect(response).to eq("Автомобиль")
      end
    end

    it 'returns pl translalation' do
      VCR.use_cassette('get_translated_pl_text') do
        response = translator.translate('Car', 'pl')
        expect(response).to eq("Samochód")
      end
    end

    it 'accepts options' do
      VCR.use_cassette('accepts options') do
        response = translator.translate('Car', from: :ru)
        expect(response).to eq("Автомобиль")
      end
    end

    context 'with two languages' do
      it 'accepts options' do
        VCR.use_cassette('accepts options') do
          response = translator.translate('Samochód', from: :pl, to: :ru)
          expect(response).to eq("Автомобиль")
        end
      end

      it 'accepts languages list' do
        VCR.use_cassette('accepts options') do
          response = translator.translate('Car', :ru, :en)
          expect(response).to eq("Автомобиль")
        end
      end
    end

    context 'with wrong api key' do
      let(:wrong_translator) { Yandex::Translator.new('wrong_api_key') }

      it 'returns translation error' do
        expect{
          VCR.use_cassette('wrong_api_key') do
            wrong_translator.translate('Car', :ru, :en)
          end
        }.to raise_error(Yandex::ApiError, "API key is invalid")
      end
    end
  end

  describe '#detect' do
    let(:detected_translation) {
      VCR.use_cassette('#detect') do
        translator.detect('Car')
      end
    }

    it 'returns detected language' do
      expect(detected_translation).to eq 'en'
    end
  end

  describe '#langs' do
    let(:list_of_langs) {
      VCR.use_cassette('#langs') do
        translator.langs
      end
    }

    it 'returns array of dirs' do
      expect(list_of_langs).to include 'en-ru', 'uk-pl', 'pl-ru'
    end

  end
end
