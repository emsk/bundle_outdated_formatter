module BundleOutdatedFormatter
  class Error < StandardError; end
  class UnknownFormatError < Error; end
  class UnknownStyleError < Error; end
  class UnknownColumnError < Error; end
end
