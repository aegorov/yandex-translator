[![Code Climate](https://codeclimate.com/repos/5255368456b102667402265a/badges/cc0cf62aa85959503fc1/gpa.png)](https://codeclimate.com/repos/5255368456b102667402265a/feed)

# Yandex::Translator

Library for Yandex Translate API | Библиотека для API Яндекс.Переводчика


## Installation

Add this line to your application's Gemfile:

    gem 'yandex-translator'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install yandex-translator

## Usage

First, set your api key:

```ruby
  Yandex::Translator.api_key = 'your.key'
```

To get list of possible translation directions use get_langs method:

```ruby
  Yandex::Translator.get_langs
```

To determine language text use detect method:

```ruby
  Yandex::Translator.detect 'Hello, world!' 
```
To translate text use translate method:

```ruby
  Yandex::Translator.translate 'Car', 'ru' 
```

In this case Yandex automatically detect text language.
If you want to set text language manually add third parameter

```ruby
  Yandex::Translator.translate 'Car', 'ru', 'en'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
