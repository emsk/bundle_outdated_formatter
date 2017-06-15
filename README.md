# BundleOutdatedFormatter

[![Gem Version](https://badge.fury.io/rb/bundle_outdated_formatter.svg)](https://badge.fury.io/rb/bundle_outdated_formatter)
[![Build Status](https://travis-ci.org/emsk/bundle_outdated_formatter.svg?branch=master)](https://travis-ci.org/emsk/bundle_outdated_formatter)
[![Coverage Status](https://coveralls.io/repos/github/emsk/bundle_outdated_formatter/badge.svg?branch=master)](https://coveralls.io/github/emsk/bundle_outdated_formatter)
[![Code Climate](https://codeclimate.com/github/emsk/bundle_outdated_formatter/badges/gpa.svg)](https://codeclimate.com/github/emsk/bundle_outdated_formatter)
[![Dependency Status](https://gemnasium.com/badges/github.com/emsk/bundle_outdated_formatter.svg)](https://gemnasium.com/github.com/emsk/bundle_outdated_formatter)
[![Inline docs](http://inch-ci.org/github/emsk/bundle_outdated_formatter.svg?branch=master)](http://inch-ci.org/github/emsk/bundle_outdated_formatter)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE.txt)

BundleOutdatedFormatter is a command-line tool to format output of `bundle outdated`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bundle_outdated_formatter'
```

And then execute:

```sh
$ bundle
```

Or install it yourself as:

```sh
$ gem install bundle_outdated_formatter
```

## Usage

### Convert to Markdown

```sh
$ bundle outdated | bof
```

## Examples

Output of `bundle outdated`:

```
Fetching gem metadata from https://rubygems.org/..........
Fetching version metadata from https://rubygems.org/...
Fetching dependency metadata from https://rubygems.org/..
Resolving dependencies...

Outdated gems included in the bundle:
* faker (newest 1.6.6, installed 1.6.5, requested ~> 1.4) in groups "development, test"
* hashie (newest 3.4.6, installed 1.2.0, requested = 1.2.0) in groups "default"
* headless (newest 2.3.1, installed 2.2.3)
```

### Convert to Markdown

```
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
| faker | 1.6.6 | 1.6.5 | ~> 1.4 | development, test |
| hashie | 3.4.6 | 1.2.0 | = 1.2.0 | default |
| headless | 2.3.1 | 2.2.3 | | |
```

## Supported Ruby Versions

* Ruby 2.0.0
* Ruby 2.1
* Ruby 2.2
* Ruby 2.3
* Ruby 2.4

## Contributing

Bug reports and pull requests are welcome.

## License

[MIT](LICENSE.txt)
