require 'thor'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  class CLI < Thor
    ALLOW_FORMAT = %w[markdown json yaml csv xml html].freeze

    default_command :output

    desc 'output', 'Format output of `bundle outdated`'
    option :format, type: :string, aliases: '-f', default: 'markdown', desc: 'Format. (markdown, json, yaml, csv, xml, html)'
    option :pretty, type: :boolean, aliases: '-p', desc: '`true` if pretty output.'

    def output
      return if STDIN.tty?
      return unless allow_format?

      formatter = Formatter.new(options)
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
  end
end
