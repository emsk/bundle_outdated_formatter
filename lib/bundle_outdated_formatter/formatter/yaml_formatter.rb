require 'psych'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for YAML
  class YAMLFormatter < Formatter
    def convert
      @outdated_gems.to_yaml.chomp
    end
  end
end
