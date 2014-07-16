# AppAnnie

[![Build Status](https://travis-ci.org/modeset/app_annie.png)](https://travis-ci.org/modeset/app_annie)
[![Gem Version](https://badge.fury.io/rb/app_annie.png)](http://badge.fury.io/rb/app_annie)

Simple Ruby wrapper for [App Annie's](http://www.appannie.com/) [analytics API](http://support.appannie.com/categories/20082753-Analytics-API)

## Installation

Add this line to your application's Gemfile:

    gem 'app_annie'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install app_annie

## Usage

First, set your AppAnnie API key. You can do this via the `APPANNIE_API_KEY` environment variable, or by setting `AppAnnie.api_key`

### Intelligence API

(after setting your api key)
```ruby
AppAnnie::Intelligence.top_app_charts(options)
```

* required options: `market`, `device`, and `categories`
* default options: `vertical: 'apps'`, `countries: 'US'`
* all other options get passed as query params. See Intelligence API docs

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
