module Pdfminer
  class Parser
    getter texts, response, config

    @config = Pdfminer.config

    delegate title, description, to: @texts
    delegate images, to: @images
    delegate videos, to: @videos

    def initialize(url : String)
      @url = url
      @response = get_request(url).as(HTTP::Client::Response)
      @channel = Channel(Pdfminer::ResponseType).new(3)
      @root = ::File.join ["/storage"]
      @filename = "#{Time.new.epoch}.pdf"
      @file_path = ::File.join [@root, @filename]

      File.write(@file_path, @response.body)
    end

    def result : Array(ResponseType)
      spawn do
        result = Pdfminer::Parsers::Text.new(@file_path, @root).result
        @channel.send(result)
      end

      spawn do
        result = Pdfminer::Parsers::Image.new(@file_path, @root).result
        @channel.send(result)
      end

      spawn do
        result = Pdfminer::Parsers::Meta.new(@file_path, @root).result
        @channel.send(result)
      end

      @data = [@channel.receive.as(ResponseType),
               @channel.receive.as(ResponseType),
               @channel.receive.as(ResponseType)]
    end

    def get_request(url) : HTTP::Client::Response
      response = HTTP::Client.get(url)
      if (300..399).includes?(response.status_code)
        url = response.headers["Location"]
        response = get_request(url)
      end
      response
    end
  end
end
