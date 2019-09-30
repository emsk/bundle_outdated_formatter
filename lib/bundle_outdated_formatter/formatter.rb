require 'rexml/document'

module BundleOutdatedFormatter
  # Formatter for all formats
  class Formatter
    GEM_REGEXP       = /\A\* (?<gem>.+) \(/
    NEWEST_REGEXP    = /newest (?<newest>[\d\.]+)/
    INSTALLED_REGEXP = /installed (?<installed>[\d\.]+)/
    REQUESTED_REGEXP = /requested (?<requested>.+)\)/
    GROUPS_REGEXP    = /in groups "(?<groups>.+)"/

    def initialize(options)
      @pretty = options[:pretty]
      @style = options[:style]
      @columns = options[:column]
      @outdated_gems = []
    end

    def read_stdin
      @outdated_gems = STDIN.each.to_a.map(&:strip).reject(&:empty?)

      @outdated_gems.map! do |line|
        find_gem(line)
      end

      @outdated_gems.compact!
    end

    private

    def find_gem(line)
      matched = match_gem(line)
      return unless match_gem?(matched)

      gems = {}
      @columns.each do |column|
        gems[column] = gem_text(matched[column.to_sym], column.to_sym)
      end
      gems
    end

    def match_gem(line)
      gems = {}
      @columns.each do |column|
        gems[column.to_sym] = self.class.const_get("#{column.upcase}_REGEXP").match(line)
      end
      gems
    end

    def match_gem?(matched)
      @columns.any? do |column|
        !matched[column.to_sym].nil?
      end
    end

    def gem_text(text, name)
      text ? text[name] : ''
    end

    def xml_formatter
      return REXML::Formatters::Default.new unless @pretty

      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      formatter
    end
  end
end
