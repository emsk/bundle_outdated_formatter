require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for Markdown
  class MarkdownFormatter < Formatter
    def convert
      @outdated_gems.map! do |gem|
        "| #{gem.values.join(' | ')} |".gsub(/  /, ' ')
      end

      (header + @outdated_gems.join("\n")).chomp
    end

    private

    def header
      <<-EOS
| #{@columns.join(' | ')} |
| #{Array.new(@columns.size, '---').join(' | ')} |
      EOS
    end
  end
end
