require 'csv'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for CSV
  class CSVFormatter < Formatter
    def convert
      text = CSV.generate(force_quotes: true) do |csv|
        csv << COLUMNS
        @outdated_gems.each do |gem|
          csv << gem.values
        end
      end
      text.chomp
    end
  end
end
