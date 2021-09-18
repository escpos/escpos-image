require_relative "errors"
require_relative "image_processors/chunky_png"
require_relative "image_processors/mini_magick"

module Escpos

  # Images
  IMAGE = [ 0x1d, 0x76, 0x30, 0x00 ] # Start image pixel data

  class Image

    VERSION = "0.0.11"

    attr_reader :processor, :options

    def initialize(image_or_path, options = {})
      @options = options

      processor_klass = get_processor_klass(options[:processor])
      @processor = processor_klass.new(image_or_path, options)

      @processor.process!
    end

    def to_escpos
      bits = []
      mask = 0x80
      i = 0
      temp = 0

      0.upto(processor.image.height - 1) do |y|
        0.upto(processor.image.width - 1) do |x|
          px = processor.get_pixel(x, y)
          value = px >= 128 ? 255 : 0
          value = (value << 8) | value
          temp |= mask if value == 0
          mask = mask >> 1
          i = i + 1
          if i == 8
            bits << temp
            mask = 0x80
            i = 0
            temp = 0
          end
        end
      end

      [
        Escpos.sequence(IMAGE),
        [ processor.image.width / 8, processor.image.height ].pack("SS"),
        bits.pack("C*")
      ].join
    end

    private

    def get_processor_klass(processor)
      return default_processor_klass unless processor

      case processor.to_s.downcase.gsub(/[_-]/, '')
      when 'minimagick' then ImageProcessors::MiniMagick
      when 'chunkypng' then ImageProcessors::ChunkyPng
      else raise("Escpos:Image unknown processor value #{processor.inspect}")
      end
    end

    def default_processor_klass
      if defined?(MiniMagick)
        ImageProcessors::MiniMagick
      elsif defined?(ChunkyPNG)
        ImageProcessors::ChunkyPng
      else
        raise('Escpos:Image requires either mini_magick or chunky_png gem.')
      end
    end
  end
end
