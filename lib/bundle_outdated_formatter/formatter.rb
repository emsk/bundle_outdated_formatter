require 'json'
require 'psych'
require 'csv'
require 'rexml/document'

module BundleOutdatedFormatter
  class Formatter
    NAME_REGEXP      = /\A(\* )*(?<name>.+) \(/
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
        matched_name      = NAME_REGEXP.match(line)
        matched_newest    = NEWEST_REGEXP.match(line)
        matched_installed = INSTALLED_REGEXP.match(line)
        matched_requested = REQUESTED_REGEXP.match(line)
        matched_groups    = GROUPS_REGEXP.match(line)

        if matched_name.nil? && matched_newest.nil? && matched_installed.nil? && matched_requested.nil? && matched_groups.nil?
          nil
        else
          {
            'gem'       => gem_text(matched_name, :name),
            'newest'    => gem_text(matched_newest, :newest),
            'installed' => gem_text(matched_installed, :installed),
            'requested' => gem_text(matched_requested, :requested),
            'groups'    => gem_text(matched_groups, :groups)
          }
        end
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
