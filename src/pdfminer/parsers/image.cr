module Pdfminer
  module Parsers
    class Image
      @config = Pdfminer.config
      getter file_path, config

      def initialize(@file_path : String, @root : String)
      end

      def result : ResponseType
        format = "png"
        density = "150"
        size = "1000x"
        common    = "#{MEMORY_ARGS} -density #{config.image_density} -resize #{config.image_size} #{quality_arg(config.image_format)}"
        out_file  = "#{file_path}.#{config.image_format}"
        tempdir = @root
        cmd = "MAGICK_TMPDIR=#{tempdir} OMP_NUM_THREADS=2 gm convert +adjoin -define pdf:use-cropbox=true #{common} #{file_path}[0] #{out_file} 2>&1".chomp
        config.run(cmd)
        {type: "image", data: out_file}
      end

      def quality_arg(format : String | Bool) : String
        case format
        when /jpe?g/ then "-quality 85"
        when /png/   then "-quality 100"
        else ""
        end
      end
    end
  end
end
