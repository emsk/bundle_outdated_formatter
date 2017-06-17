require 'thor'
require 'json'
require 'csv'
require 'rexml/document'

module BundleOutdatedFormatter
  class CLI < Thor
    NAME_REGEXP      = /\A(\* )*(?<name>.+) \(/.freeze
    NEWEST_REGEXP    = /newest (?<newest>[\d\.]+)/.freeze
    INSTALLED_REGEXP = /installed (?<installed>[\d\.]+)/.freeze
    REQUESTED_REGEXP = /requested (?<requested>.+)\)/.freeze
    GROUPS_REGEXP    = /in groups "(?<groups>.+)"/.freeze

    MARKDOWN_HEADER = <<-EOS.freeze
| gem | newest | installed | requested | groups |
| --- | --- | --- | --- | --- |
    EOS
    COLUMNS = %w[gem newest installed requested groups].freeze

    default_command :output

    desc 'output', 'Format output of `bundle outdated`'
    option :format, type: :string, aliases: '-f', default: 'markdown'

    def output
      return if STDIN.tty?

      case options[:format]
      when 'markdown'
        puts format_markdown(outdated_gems_in_stdin)
      when 'json'
        puts format_json(outdated_gems_in_stdin)
      when 'csv'
        puts format_csv(outdated_gems_in_stdin)
      when 'xml'
        puts format_xml(outdated_gems_in_stdin)
      when 'html'
        puts format_html(outdated_gems_in_stdin)
      end
    end

    desc 'version, -v, --version', 'Print the version'
    map %w[-v --version] => :version

    def version
      puts "bundle_outdated_formatter #{BundleOutdatedFormatter::VERSION}"
    end

    private

    def outdated_gems_in_stdin
      outdated_gems = STDIN.each.to_a.map(&:strip).reject(&:empty?)

      outdated_gems.map! do |line|
        matched_name      = NAME_REGEXP.match(line)
        matched_newest    = NEWEST_REGEXP.match(line)
        matched_installed = INSTALLED_REGEXP.match(line)
        matched_requested = REQUESTED_REGEXP.match(line)
        matched_groups    = GROUPS_REGEXP.match(line)

        if matched_name.nil? && matched_newest.nil? && matched_installed.nil? && matched_requested.nil? && matched_groups.nil?
          nil
        else
          {
            gem:       gem_text(matched_name, :name),
            newest:    gem_text(matched_newest, :newest),
            installed: gem_text(matched_installed, :installed),
            requested: gem_text(matched_requested, :requested),
            groups:    gem_text(matched_groups, :groups)
          }
        end
      end

      outdated_gems.compact
    end

    def gem_text(text, name)
      text ? text[name] : ''
    end

    def format_markdown(outdated_gems)
      outdated_gems.map! do |gem|
        "| #{gem.values.join(' | ')} |".gsub(/  /, ' ')
      end

      MARKDOWN_HEADER + outdated_gems.join("\n")
    end

    def format_json(outdated_gems)
      outdated_gems.to_json
    end

    def format_csv(outdated_gems)
      CSV.generate(force_quotes: true) do |csv|
        csv << COLUMNS
        outdated_gems.each do |gem|
          csv << gem.values
        end
      end
    end

    def format_xml(outdated_gems)
      xml = REXML::Document.new(nil, raw: :all)
      xml << REXML::XMLDecl.new('1.0', 'UTF-8')

      root = REXML::Element.new('gems')
      xml.add_element(root)

      outdated_gems.each do |gem|
        elements = root.add_element(REXML::Element.new('outdated'))

        COLUMNS.each do |column|
          elements.add_element(column).add_text(gem[column.to_sym])
        end
      end

      xml
    end

    def format_html(outdated_gems)
      html = REXML::Document.new(nil, raw: :all)

      root = REXML::Element.new('table')
      html.add_element(root)

      elements = root.add_element(REXML::Element.new('tr'))
      COLUMNS.each do |column|
        elements.add_element('th').add_text(column)
      end

      outdated_gems.each do |gem|
        elements = root.add_element(REXML::Element.new('tr'))

        COLUMNS.each do |column|
          elements.add_element('td').add_text(gem[column.to_sym])
        end
      end

      html
    end
  end
end
