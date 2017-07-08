require 'json'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for JSON
  class JSONFormatter < Formatter
    def convert
      text = @pretty ? JSON.pretty_generate(@outdated_gems) : @outdated_gems.to_json
      text.chomp
    end
  end
end
