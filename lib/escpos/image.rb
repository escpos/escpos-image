require_relative "errors"
require_relative "image_processors/chunky_png"
require_relative "image_processors/mini_magick"

module Escpos

  # Images
  IMAGE = [ 0x1d, 0x76, 0x30, 0x00 ] # Start image pixel data

  class Image

    VERSION = "0.0.9"

    attr_reader :processor, :options

    def initialize(image_or_path, options = {})
      @options = options

      processor_klass_name = options.fetch(:processor, "ChunkyPng")
      processor_klass = ImageProcessors.const_get(processor_klass_name)
      @processor = processor_klass.new image_or_path, options

      @processor.process!
    end

    def chunky_png_image
      processor.chunky_png_image
    end

    def to_escpos
      bits = []
      mask = 0x80
      i = 0
      temp = 0

      0.upto(chunky_png_image.height - 1) do |y|
        0.upto(chunky_png_image.width - 1) do |x|
          px = chunky_png_image.get_pixel(x, y)
          r, g, b =
            ChunkyPNG::Color.r(px),
            ChunkyPNG::Color.g(px),
            ChunkyPNG::Color.b(px)

          px = (r + b + g) / 3        
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
        [ chunky_png_image.width / 8, chunky_png_image.height ].pack("SS"),
        bits.pack("C*")
      ].join
    end

  end
end
