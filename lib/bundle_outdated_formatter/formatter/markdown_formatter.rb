require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  class MarkdownFormatter < Formatter
    MARKDOWN_HEADER = <<-EOS.freeze
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
    EOS

    def convert
      @outdated_gems.map! do |gem|
        "| #{gem.values.join(' | ')} |".gsub(/  /, ' ')
      end

      (MARKDOWN_HEADER + @outdated_gems.join("\n")).chomp
    end
  end
end
