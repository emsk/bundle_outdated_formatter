lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bundle_outdated_formatter/version'

Gem::Specification.new do |spec|
  spec.name          = 'bundle_outdated_formatter'
  spec.version       = BundleOutdatedFormatter::VERSION
  spec.authors       = ['emsk']
  spec.email         = ['emsk1987@gmail.com']

  spec.summary       = 'Formatter for `bundle outdated`'
  spec.description   = 'BundleOutdatedFormatter is a command-line tool to format output of `bundle outdated`'
  spec.homepage      = 'https://github.com/emsk/bundle_outdated_formatter'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'psych', '>= 2.2'
  spec.add_runtime_dependency 'rexml', '~> 3.2'
  spec.add_runtime_dependency 'thor', '>= 0.20'
  spec.add_runtime_dependency 'tty-table', '~> 0.10'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'codecov'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 3.9'
  if RUBY_PLATFORM !~ /mingw/
    spec.add_development_dependency 'rubocop', '~> 0.76'
    spec.add_development_dependency 'rubocop-rspec', '~> 1.36'
  end
  spec.add_development_dependency 'simplecov'
end
