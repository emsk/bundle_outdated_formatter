require 'json'
require 'psych'
require 'csv'
require 'rexml/document'

module BundleOutdatedFormatter
  class Formatter
    GEM_REGEXP       = /\A(\* )*(?<gem>.+) \(/
    NEWEST_REGEXP    = /newest (?<newest>[\d\.]+)/
    INSTALLED_REGEXP = /installed (?<installed>[\d\.]+)/
    REQUESTED_REGEXP = /requested (?<requested>.+)\)/
    GROUPS_REGEXP    = /in groups "(?<groups>.+)"/

    MARKDOWN_HEADER = <<-EOS.freeze
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
    EOS
    COLUMNS = %w[gem newest installed requested groups].freeze

    def initialize(options)
      @format = options[:format]
      @pretty = options[:pretty]
      @outdated_gems = []
    end

    def read_stdin
      @outdated_gems = STDIN.each.to_a.map(&:strip).reject(&:empty?)

      @outdated_gems.map! do |line|
        find_gems(line)
      end

      @outdated_gems.compact!
    end

    def convert
      text =
        case @format
        when 'markdown' then format_markdown
        when 'json'     then format_json
        when 'yaml'     then format_yaml
        when 'csv'      then format_csv
        when 'xml'      then format_xml
        when 'html'     then format_html
        else                 ''
        end
      text.chomp
    end

    private

    def find_gems(line)
      matched = {
        gem:       GEM_REGEXP.match(line),
        newest:    NEWEST_REGEXP.match(line),
        installed: INSTALLED_REGEXP.match(line),
        requested: REQUESTED_REGEXP.match(line),
        groups:    GROUPS_REGEXP.match(line)
      }

      return unless match_gem?(matched)

      {
        'gem'       => gem_text(matched[:gem], :gem),
        'newest'    => gem_text(matched[:newest], :newest),
        'installed' => gem_text(matched[:installed], :installed),
        'requested' => gem_text(matched[:requested], :requested),
        'groups'    => gem_text(matched[:groups], :groups)
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

    def format_markdown
      @outdated_gems.map! do |gem|
        "| #{gem.values.join(' | ')} |".gsub(/  /, ' ')
      end

      MARKDOWN_HEADER + @outdated_gems.join("\n")
    end

    def format_json
      return JSON.pretty_generate(@outdated_gems) if @pretty
      @outdated_gems.to_json
    end

    def format_yaml
      @outdated_gems.to_yaml
    end

    def format_csv
      CSV.generate(force_quotes: true) do |csv|
        csv << COLUMNS
        @outdated_gems.each do |gem|
          csv << gem.values
        end
      end
    end

    def format_xml
      xml = REXML::Document.new(nil, raw: :all)
      xml << REXML::XMLDecl.new('1.0', 'UTF-8')

      root = REXML::Element.new('gems')
      xml.add_element(root)

      @outdated_gems.each do |gem|
        elements = root.add_element(REXML::Element.new('outdated'))

        COLUMNS.each do |column|
          elements.add_element(column).add_text(gem[column])
        end
      end

      io = StringIO.new
      xml_formatter.write(xml, io)
      io.string
    end

    def format_html
      html = REXML::Document.new(nil, raw: :all)

      root = REXML::Element.new('table')
      html.add_element(root)

      elements = root.add_element(REXML::Element.new('tr'))
      COLUMNS.each do |column|
        elements.add_element('th').add_text(column)
      end

      @outdated_gems.each do |gem|
        elements = root.add_element(REXML::Element.new('tr'))

        COLUMNS.each do |column|
          elements.add_element('td').add_text(gem[column])
        end
      end

      io = StringIO.new
      xml_formatter.write(html, io)
      io.string
    end

    def xml_formatter
      return REXML::Formatters::Default.new unless @pretty

      formatter = REXML::Formatters::Pretty.new
      formatter.compact = true
      formatter
    end
  end
end
