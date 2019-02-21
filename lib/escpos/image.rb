module Escpos
  class Image

    VERSION = "0.0.6"

    attr_reader :options

    def initialize(image_or_path, options = {})
      @options = options
      if image_or_path.is_a?(ChunkyPNG::Image)
        @image = image_or_path
      elsif image_or_path.is_a?(String)
        if options.fetch(:convert_to_monochrome, false)
          require_mini_magick!
          image = convert_to_monochrome(image_or_path)
          @image = ChunkyPNG::Image.from_file(image.path)
        else
          @image = ChunkyPNG::Image.from_file(image_or_path)
        end
      else
        raise ArgumentError.new("Image must be a path or a ChunkyPNG::Image object.")
      end

      unless @image.width % 8 == 0 && @image.height % 8 == 0
        raise ArgumentError.new("Image width and height must be a multiple of 8.")
      end
    end

    def to_escpos
      bits = []
      mask = 0x80
      i = 0
      temp = 0

      0.upto(@image.height - 1) do |y|
        0.upto(@image.width - 1) do |x|
          px = ChunkyPNG::Color.to_grayscale(@image.get_pixel(x, y))
          r, g, b, a =
            ChunkyPNG::Color.r(px),
            ChunkyPNG::Color.g(px),
            ChunkyPNG::Color.b(px),
            ChunkyPNG::Color.a(px)
          px = (r + b + g) / 3
          # Alpha is flattened with convert_to_monochrome option
          handled_by_mini_magick = options.fetch(:convert_to_monochrome, false)
          if !handled_by_mini_magick && options.fetch(:compose_alpha, true)
            bg_color = options.fetch(:compose_alpha_bg, 255)
            a_quot = a / 255.0
            px = (((1 - a_quot) * bg_color) + (a_quot * px)).to_i
          end
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
        [@image.width / 8, @image.height ].pack("SS"),
        bits.pack("C*")
      ].join
    end

    def chunky_png_image
      @image
    end

    private

    # !!!
    # Please note that MiniMagick gem is not required _intentionally_
    # This makes the gem more lightweight by making this dependency optional
    # !!!
    def require_mini_magick!
      unless defined?(MiniMagick)
        begin 
          require 'mini_magick'
        rescue LoadError => e
          raise "Required options need the mini_magick gem installed: #{e}."
        end
      end
    end

    def convert_to_monochrome(image_path)
      image = MiniMagick::Image.open(image_path)

      # Flatten transparency
      image.flatten

      # Get the first image out of animated gifs
      image.collapse!

      # Optimise more actions to single call
      image.combine_options do |c|
        c.rotate options.fetch(:rotate) if options.has_key?(:rotate)
        c.resize options.fetch(:resize) if options.has_key?(:resize)
        c.grayscale 'Rec709Luma'
        if options.fetch(:dither, true)
          c.monochrome '+dither'
          # dither the image with FloydSteinberg algoritm for better results
          c.dither 'FloydSteinberg'
        else
          c.monochrome '+dither' # + operator disables dithering
        end
      end

      # Limit the extent of the image to nice round numbers
      if options.fetch(:extent, true)
        image.extent "#{(image.width/8.0).round*8}x#{(image.height/8.0).round*8}"
      end

      # Force PNG format so ChunkyPNG works
      image.format 'png'

      image
    end

  end
end
