require 'rexml/document'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  class XMLFormatter < Formatter
    def convert
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
      io.string.chomp
    end
  end
end
