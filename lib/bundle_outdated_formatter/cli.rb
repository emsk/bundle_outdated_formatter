require 'thor'
require 'bundle_outdated_formatter/error'
require 'bundle_outdated_formatter/formatter/terminal_formatter'
require 'bundle_outdated_formatter/formatter/markdown_formatter'
require 'bundle_outdated_formatter/formatter/json_formatter'
require 'bundle_outdated_formatter/formatter/yaml_formatter'
require 'bundle_outdated_formatter/formatter/csv_formatter'
require 'bundle_outdated_formatter/formatter/tsv_formatter'
require 'bundle_outdated_formatter/formatter/xml_formatter'
require 'bundle_outdated_formatter/formatter/html_formatter'

module BundleOutdatedFormatter
  # Command-line interface of {BundleOutdatedFormatter}
  class CLI < Thor
    FORMATTERS = {
      'terminal' => TerminalFormatter,
      'markdown' => MarkdownFormatter,
      'json'     => JSONFormatter,
      'yaml'     => YAMLFormatter,
      'csv'      => CSVFormatter,
      'tsv'      => TSVFormatter,
      'xml'      => XMLFormatter,
      'html'     => HTMLFormatter
    }.freeze
    STYLES = %w[unicode ascii].freeze
    COLUMNS = %w[gem newest installed requested groups].freeze

    def self.exit_on_failure?
      false
    end

    default_command :output

    desc 'output', 'Format output of `bundle outdated`'
    option :format, type: :string, aliases: '-f', default: 'terminal', desc: 'Format. (terminal, markdown, json, yaml, csv, tsv, xml, html)'
    option :pretty, type: :boolean, aliases: '-p', desc: '`true` if pretty output.'
    option :style, type: :string, aliases: '-s', default: 'unicode', desc: 'Terminal table style. (unicode, ascii)'
    option :column, type: :array, aliases: '-c', default: %w[gem newest installed requested groups], desc: 'Output columns. (columns are sorted in specified order)'

    def output
      raise BundleOutdatedFormatter::UnknownFormatError, options[:format] unless allow_format?
      raise BundleOutdatedFormatter::UnknownStyleError, options[:style] unless allow_style?
      raise BundleOutdatedFormatter::UnknownColumnError, options[:column] unless allow_column?
      return if STDIN.tty?

      formatter = create_formatter
      formatter.read_stdin
      puts formatter.convert
    end

    desc 'version, -v, --version', 'Print the version'
    map %w[-v --version] => :version

    def version
      puts "bundle_outdated_formatter #{BundleOutdatedFormatter::VERSION}"
    end

    private

    def allow_format?
      FORMATTERS.key?(options[:format])
    end

    def allow_style?
      STYLES.include?(options[:style])
    end

    def allow_column?
      options[:column].all? do |column|
        COLUMNS.include?(column)
      end
    end

    def create_formatter
      FORMATTERS[options[:format]].new(options)
    end
  end
end
