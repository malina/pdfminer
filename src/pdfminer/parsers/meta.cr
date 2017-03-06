module Pdfminer
  module Parsers
    class Meta
      @config = Pdfminer.config
      getter file_path, config
      def initialize(@file_path : String, @root : String)
      end

      def extract(key, pdfs, opts)
        extract_all(pdfs, opts)[key]
      end

      def result : Pdfminer::ResponseType
        cmd = "pdfinfo #{file_path} 2>&1"
        result = config.run(cmd)

        info = {} of Symbol => String | Int32 | Nil
        MATCHERS.each do |key, matcher|
          match = result.match(matcher)
          answer = match && match[1]
          if answer
            answer = answer.to_i if key == :length
            info[key] = answer
          end
        end
        {type: "meta", data: info}
      end
    end
  end
end
