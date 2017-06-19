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

```sh
$ bundle outdated | bof
```

## Command Options

| Option | Alias | Description | Default |
| :----- | :---- | :---------- | :------ |
| `--format` | `-f` | Format. `markdown`, `json`, `yaml`, `csv`, `xml`, or `html`. | `markdown` |

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

### Convert to JSON

```
[{"gem":"faker","newest":"1.6.6","installed":"1.6.5","requested":"~> 1.4","groups":"development, test"},{"gem":"hashie","newest":"3.4.6","installed":"1.2.0","requested":"= 1.2.0","groups":"default"},{"gem":"headless","newest":"2.3.1","installed":"2.2.3","requested":"","groups":""}]
```

### Convert to YAML

```
---
- gem: faker
  newest: 1.6.6
  installed: 1.6.5
  requested: "~> 1.4"
  groups: development, test
- gem: hashie
  newest: 3.4.6
  installed: 1.2.0
  requested: "= 1.2.0"
  groups: default
- gem: headless
  newest: 2.3.1
  installed: 2.2.3
  requested: ''
  groups: ''
```

### Convert to CSV

```
"gem","newest","installed","requested","groups"
"faker","1.6.6","1.6.5","~> 1.4","development, test"
"hashie","3.4.6","1.2.0","= 1.2.0","default"
"headless","2.3.1","2.2.3","",""
```

### Convert to XML

```
<?xml version='1.0' encoding='UTF-8'?><gems><outdated><gem>faker</gem><newest>1.6.6</newest><installed>1.6.5</installed><requested>~> 1.4</requested><groups>development, test</groups></outdated><outdated><gem>hashie</gem><newest>3.4.6</newest><installed>1.2.0</installed><requested>= 1.2.0</requested><groups>default</groups></outdated><outdated><gem>headless</gem><newest>2.3.1</newest><installed>2.2.3</installed><requested></requested><groups></groups></outdated></gems>
```

### Convert to HTML

```
<table><tr><th>gem</th><th>newest</th><th>installed</th><th>requested</th><th>groups</th></tr><tr><td>faker</td><td>1.6.6</td><td>1.6.5</td><td>~> 1.4</td><td>development, test</td></tr><tr><td>hashie</td><td>3.4.6</td><td>1.2.0</td><td>= 1.2.0</td><td>default</td></tr><tr><td>headless</td><td>2.3.1</td><td>2.2.3</td><td></td><td></td></tr></table>
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
