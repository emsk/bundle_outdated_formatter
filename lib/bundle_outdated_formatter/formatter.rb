require 'rexml/document'

module BundleOutdatedFormatter
  class Formatter
    GEM_REGEXP       = /\A(\* )*(?<gem>.+) \(/
    NEWEST_REGEXP    = /newest (?<newest>[\d\.]+)/
    INSTALLED_REGEXP = /installed (?<installed>[\d\.]+)/
    REQUESTED_REGEXP = /requested (?<requested>.+)\)/
    GROUPS_REGEXP    = /in groups "(?<groups>.+)"/

    COLUMNS = %w[gem newest installed requested groups].freeze

    def initialize(options)
      @pretty = options[:pretty]
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

      {
        'gem'       => gem_text(matched[:gem], :gem),
        'newest'    => gem_text(matched[:newest], :newest),
        'installed' => gem_text(matched[:installed], :installed),
        'requested' => gem_text(matched[:requested], :requested),
        'groups'    => gem_text(matched[:groups], :groups)
      }
    end

    def match_gem(line)
      {
        gem:       GEM_REGEXP.match(line),
        newest:    NEWEST_REGEXP.match(line),
        installed: INSTALLED_REGEXP.match(line),
        requested: REQUESTED_REGEXP.match(line),
        groups:    GROUPS_REGEXP.match(line)
      }
    end

    def match_gem?(matched)
      COLUMNS.any? do |column|
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
