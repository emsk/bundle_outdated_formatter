require 'rexml/document'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  class HTMLFormatter < Formatter
    def convert
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
      io.string.chomp
    end
  end
end
