module Pdfminer
  OCR_FLAGS   = "-density 400x400 -colorspace GRAY"
  MEMORY_ARGS = "-limit memory 256MiB -limit map 512MiB"

  MATCHERS = {
    author: /^Author:\s+([^\n]+)/,
    date: /^CreationDate:\s+([^\n]+)/,
    creator: /^Creator:\s+([^\n]+)/,
    keywords: /^Keywords:\s+([^\n]+)/,
    producer: /^Producer:\s+([^\n]+)/,
    subject: /^Subject:\s+([^\n]+)/,
    title: /^Title:\s+([^\n]+)/,
    length: /^Pages:\s+([^\n]+)/
  }

  alias ResponseType = NamedTuple(type: String, data: String | Hash(Symbol, String | Int32 | Nil))

  class Config
    INSTANCE = Config.new
    property image_format, image_density, image_size, skip_ocr, url, uri

    def initialize
      @url = ""
      @uri = URI.new
      @image_format = "jpg".as(String | Bool)
      @image_density = "150".as(String | Bool)
      @image_size = "1000x".as(String | Bool)
      @skip_ocr = false.as(Bool | String)
    end

    def run(command)
      io = IO::Memory.new
      Process.run(command, shell: true, output: io)
      result = io.to_s.chomp
    rescue
      raise "ExtractionFailed"
    end
  end

  def self.config
    yield Config::INSTANCE
  end

  def self.config
    Config::INSTANCE
  end
end
