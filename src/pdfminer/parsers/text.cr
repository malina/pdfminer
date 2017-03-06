module Pdfminer
  module Parsers
    class Text
      @config = Pdfminer.config
      getter file_path, config
      def initialize(@file_path : String, @root : String)
      end

      def result : Pdfminer::ResponseType
        data = extract_from_pdf

        if data[:data].empty? && !config.skip_ocr
          data = extract_from_pdf
        end

        data
      end

      def extract_from_ocr  : ResponseType
        tempdir = @root
        config.run("MAGICK_TMPDIR=#{tempdir} OMP_NUM_THREADS=2 gm convert -despeckle +adjoin #{Pdfminer::OCR_FLAGS} #{Pdfminer::MEMORY_ARGS} #{file_path}[0] #{file_path}.tif 2>&1")
        result = config.run("tesseract #{file_path}.tif stdout")
        {type: "text", data: result}
      end

      def extract_from_pdf : ResponseType
        result = config.run("pdftotext -enc UTF-8 -f 1 -l 1 #{file_path} #{file_path}.txt 2>&1")
        file = File.read("#{file_path}.txt")
        {type: "text", data: file}
      end
    end
  end
end
