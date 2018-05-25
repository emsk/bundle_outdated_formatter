require 'rexml/document'
require 'bundle_outdated_formatter/formatter'

module BundleOutdatedFormatter
  # Formatter for XML
  class XMLFormatter < Formatter
    def initialize(options)
      super(options)

      @xml = REXML::Document.new(nil, raw: :all)
      @root = REXML::Element.new('gems')
      @root.add_text('')
      @xml.add_element(@root)
    end

    def convert
      @outdated_gems.each do |gem|
        add_outdated(gem)
      end

      io = StringIO.new
      io.write('<?xml version="1.0" encoding="UTF-8"?>')
      io.write("\n") if @pretty
      xml_formatter.write(@xml, io)
      io.string.chomp
    end

    private

    def add_outdated(gem)
      elements = @root.add_element(REXML::Element.new('outdated'))

      COLUMNS.each do |column|
        escaped_text = REXML::Text.new(gem[column], false, nil, false)
        elements.add_element(column).add_text(escaped_text)
      end
    end
  end
end
