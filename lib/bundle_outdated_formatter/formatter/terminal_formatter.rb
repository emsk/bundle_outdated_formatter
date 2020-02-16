require 'tty-table'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for Terminal
  class TerminalFormatter < Formatter
    def convert
      table.render(@style.to_sym, padding: [0, 1]).chomp
    end

    private

    def table
      return TTY::Table.new([@columns]) if @outdated_gems.empty?

      TTY::Table.new(header: @columns) do |t|
        @outdated_gems.each do |gem|
          t << gem.values
        end
      end
    end
  end
end
