require 'terminal-table'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for Terminal
  class TerminalFormatter < Formatter
    def convert
      table = Terminal::Table.new do |t|
        t << COLUMNS
        t << :separator
        @outdated_gems.each do |gem|
          t << gem.values
        end
      end
      table.render.chomp
    end
  end
end
