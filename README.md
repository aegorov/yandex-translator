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

First, create translator using your api key:

```ruby
  translator = Yandex::Translator.new('your.key')
```

To get list of possible translation directions use #langs method:

```ruby
  translator.langs
```

To determine language text use detect method:

```ruby
  translator.detect 'Hello, world!'
```
To translate text use translate method:

```ruby
  translator.translate 'Car', from: 'ru'
```

In this case Yandex automatically detect text language.
If you want to set text language manually add third parameter

```ruby
  translator.translate 'Car', from: 'ru', to: 'en'
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
