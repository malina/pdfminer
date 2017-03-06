require "./pdfminer/*"
require "./pdfminer/*"
require "./pdfminer/parsers/*"
require "uri"
require "http/client"

module Pdfminer
  def self.new(url : String, options = {} of Symbol => String | Bool)
    Pdfminer.config do |config|
      config.url = url
      config.uri = URI.parse(url)

      config.image_format = options.fetch(:image_format) { config.image_format }
      config.image_density = options.fetch(:image_density) { config.image_density }
      config.image_size = options.fetch(:image_size) { config.image_size }
      config.skip_ocr = options.fetch(:skip_ocr) { config.skip_ocr }
    end

    Parser.new(url).result
  end
end
