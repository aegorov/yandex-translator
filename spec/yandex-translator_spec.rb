# encoding: UTF-8

require 'spec_helper'

describe Yandex::Translator do

  before do
    Yandex::Translator.set_api_key(ENV['API_KEY'])
  end

  it "shoud return right translation" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/translate?key=#{ENV['API_KEY']}&lang=ru&text=Car").
      to_return(:body => "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<Translation code=\"200\" lang=\"en-ru\"><text>Автомобиль</text></Translation>")
    Yandex::Translator.translate("Car", "ru").should == "Автомобиль"
  end

  it "should return translation error when translate to the same language" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/translate?key=#{ENV['API_KEY']}&lang=ru-ru&text=Car").
      to_return(:body => "TrService1: Invalid parameter 'lang'" )
    expect{
      Yandex::Translator.translate("Car", "ru", "ru")
    }.to raise_error(Yandex::Translator::TranslationError, "Can't translate text to ru")
  end

  it "should return translation error when translate from unknown language" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/translate?key=#{ENV['API_KEY']}&lang=unknown-ru&text=Car").
      to_return(:body => "TrService1: Invalid parameter 'lang'" )
    expect{
      Yandex::Translator.translate("Car", "ru", "unknown")
    }.to raise_error(Yandex::Translator::TranslationError, "Can't translate text to ru")
  end

  it "should return translation error when translate to unknown language" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/translate?key=#{ENV['API_KEY']}&lang=ru-unknown&text=Car").
      to_return(:body => "TrService1: Invalid parameter 'lang'" )
    expect{
      Yandex::Translator.translate("Car", "unknown", "ru")
    }.to raise_error(Yandex::Translator::TranslationError, "Can't translate text to unknown")
  end

  it "shoud detect en language" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/detect?key=#{ENV['API_KEY']}&text=Car").
      to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<DetectedLang code=\"200\" lang=\"en\"/>" )
    Yandex::Translator.detect("Car").should == "en"
  end

  it "shoud detect ru language" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/detect?key=#{ENV['API_KEY']}&text=Автомобиль").
      to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<DetectedLang code=\"200\" lang=\"ru\"/>" )
    Yandex::Translator.detect("Автомобиль").should == "ru"
  end

  it "shoud not detect any language" do
    stub_request(:get, "https://translate.yandex.net/api/v1.5/tr/detect?key=#{ENV['API_KEY']}&text=CarАвто").
      to_return(:body => "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<DetectedLang code=\"200\" lang=\"\"/>" )
    Yandex::Translator.detect("CarАвто").should be_nil
  end

end