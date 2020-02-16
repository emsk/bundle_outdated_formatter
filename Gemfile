source 'https://rubygems.org'

# Specify your gem's dependencies in bundle_outdated_formatter.gemspec
gemspec

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.4.0')
  gem 'simplecov', '< 0.18.0'
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.3.0')
  gem 'psych', '< 3.0.0'
end

if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create('2.2.0') && Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.3.0')
  gem 'rubocop', '< 0.69.0'
  gem 'rubocop-rspec', '< 1.33.0'
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.2.0')
  gem 'parallel', '< 1.17.0'
  gem 'rubocop-rspec', '< 1.5.2'
end

if Gem::Version.create(RUBY_VERSION) >= Gem::Version.create('2.1.0') && Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.2.0')
  gem 'rubocop', '< 0.58.0'
end

if Gem::Version.create(RUBY_VERSION) < Gem::Version.create('2.1.0')
  gem 'rubocop', '< 0.51.0'
end
