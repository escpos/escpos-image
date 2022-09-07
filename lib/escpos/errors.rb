module Escpos

  class DimensionsMustBeMultipleOf8 < ArgumentError
    def message
      "Image width and height must be a multiple of 8 or the option \"extent\" must be set to true."
    end
  end

  class InputNotSupported < ArgumentError
    def message
      "Image must be a path or an instance of e.g. ChunkyPNG::Image, MiniMagick::Image or other supported processor. See readme for details."
    end
  end

  class DependencyNotInstalled < LoadError
    attr_reader :dependency_name
    def initialize(dependency_name)
      @dependency_name = dependency_name
    end
    def message
      "Required options need the \"#{@dependency_name}\" gem installed."
    end
  end

end
