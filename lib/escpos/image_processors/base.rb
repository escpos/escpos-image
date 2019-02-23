module Escpos
  module ImageProcessors
    class Base

      attr_reader :image, :options

      def initialize(image_or_path, options = {})
        @options = options
        assert_options!
      end

      # Require correct dimensions if auto resizing is not enabled
      def assert_dimensions_multiple_of_8!
        unless options.fetch(:extent, false)
          unless image.width % 8 == 0 && image.height % 8 == 0
            raise DimensionsMustBeMultipleOf8
          end
        end      
      end

    end
  end
end