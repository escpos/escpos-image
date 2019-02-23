module Escpos

  class DimensionsMustBeMultipleOf8 < ArgumentError
    def message
      "Image width and height must be a multiple of 8 or the option \"extent\" must be set to true."
    end
  end

  class InputNotSupported < ArgumentError
    def message
      "Image must be a path or an instance of ChunkyPNG::Image or MiniMagick::Image."
    end
  end

  class MiniMagickNotInstalled < LoadError
    def message
      "Required options need the mini_magick gem installed: #{e}."
    end
  end

end
