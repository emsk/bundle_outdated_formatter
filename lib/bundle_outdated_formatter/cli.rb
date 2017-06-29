require 'thor'
require 'bundle_outdated_formatter/error'
require 'bundle_outdated_formatter/formatter/markdown_formatter'
require 'bundle_outdated_formatter/formatter/json_formatter'
require 'bundle_outdated_formatter/formatter/yaml_formatter'
require 'bundle_outdated_formatter/formatter/csv_formatter'
require 'bundle_outdated_formatter/formatter/xml_formatter'
require 'bundle_outdated_formatter/formatter/html_formatter'

module BundleOutdatedFormatter
  class CLI < Thor
    ALLOW_FORMAT = %w[markdown json yaml csv xml html].freeze

    default_command :output

    desc 'output', 'Format output of `bundle outdated`'
    option :format, type: :string, aliases: '-f', default: 'markdown', desc: 'Format. (markdown, json, yaml, csv, xml, html)'
    option :pretty, type: :boolean, aliases: '-p', desc: '`true` if pretty output.'

    def output
      raise BundleOutdatedFormatter::UnknownFormatError, options[:format] unless allow_format?
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
      ALLOW_FORMAT.include?(options[:format])
    end

    def create_formatter
      formatter =
        case options[:format]
        when 'markdown' then MarkdownFormatter
        when 'json'     then JSONFormatter
        when 'yaml'     then YAMLFormatter
        when 'csv'      then CSVFormatter
        when 'xml'      then XMLFormatter
        when 'html'     then HTMLFormatter
        end
      formatter.new(options)
    end
  end
end
