require 'rexml/document'

module BundleOutdatedFormatter
  # Formatter for all formats
  class Formatter
    GEM_REGEXP       = /\A\* (?<gem>.+) \(/.freeze
    NEWEST_REGEXP    = /newest (?<newest>[\d.]+)/.freeze
    INSTALLED_REGEXP = /installed (?<installed>[\d.]+)/.freeze
    REQUESTED_REGEXP = /requested (?<requested>.+)\)/.freeze
    GROUPS_REGEXP    = /in groups? "(?<groups>.+)"/.freeze
    TABLE_FORMAT_REGEXP = /Gem +Current +Latest +Requested +Groups/.freeze

    def initialize(options)
      @pretty = options[:pretty]
      @style = options[:style]
      @columns = options[:column]
      @outdated_gems = []
    end

    def read_stdin
      @outdated_gems = STDIN.each.to_a.map(&:strip).reject(&:empty?)

      if (header_index = find_table_header_index(@outdated_gems))
        header = @outdated_gems[header_index]
        pos = table_pos(header)
        @outdated_gems.map!.with_index do |line, index|
          find_gem_for_table_format(line, pos) if header_index < index
        end
      else
        @outdated_gems.map! do |line|
          find_gem(line)
        end
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

    def find_table_header_index(lines)
      lines.find_index { |line| line =~ TABLE_FORMAT_REGEXP }
    end

    def table_pos(header)
      current_pos = header.index('Current')
      latest_pos = header.index('Latest')
      requested_pos = header.index('Requested')
      groups_pos = header.index('Groups')
      {
        'gem'       => 0..current_pos.pred,
        'newest'    => latest_pos..requested_pos.pred,
        'installed' => current_pos..latest_pos.pred,
        'requested' => requested_pos..groups_pos.pred,
        'groups'    => groups_pos..-1
      }
    end

    def find_gem_for_table_format(line, pos)
      gems = {}
      @columns.each do |column|
        range = pos[column]
        gems[column] = line[range].to_s.strip
      end
      gems
    end

    def xml_formatter
      return REXML::Formatters::Default.new unless @pretty

      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      formatter
    end
  end
end
