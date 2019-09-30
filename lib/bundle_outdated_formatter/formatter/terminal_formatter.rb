require 'tty-table'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for Terminal
  class TerminalFormatter < Formatter
    def convert
      table = TTY::Table.new(header: @columns) do |t|
        @outdated_gems.each do |gem|
          t << gem.values
        end
      end
      table.render(@style.to_sym, padding: [0, 1]).chomp
    end
  end
end
