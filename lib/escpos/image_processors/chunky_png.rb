require_relative "base"

module Escpos
  module ImageProcessors
    class ChunkyPng < Base

      def initialize(image_or_path, options = {})
        @image = begin
          if image_or_path.is_a?(ChunkyPNG::Image)
            image_or_path
          elsif image_or_path.is_a?(String)
            ChunkyPNG::Image.from_file(image_or_path)
          else
            raise InputNotSupported
          end
        end

        super
      end

      def chunky_png_image
        @image
      end

      def assert_options!
        assert_dimensions_multiple_of_8!
      end

      def process!
        extent = options.fetch(:extent, false)
        compose_alpha = options.fetch(:compose_alpha, false)
        grayscale = options.fetch(:extent, false)

        if extent
          new_width = (image.width / 8.0).round * 8
          new_height = (image.height / 8.0).round * 8
          image.resample_nearest_neighbor!(new_width, new_height)
        end

        return if !compose_alpha && !grayscale

        if compose_alpha
          bg_r, bg_g, bg_b =
            options.fetch(:compose_alpha_bg_r, 255),
            options.fetch(:compose_alpha_bg_g, 255),
            options.fetch(:compose_alpha_bg_b, 255)
        end

        0.upto(image.height - 1) do |y|
          0.upto(image.width - 1) do |x|
            px = image.get_pixel(x, y)
            if compose_alpha
              bg_color = ChunkyPNG::Color.rgb(bg_r, bg_g, bg_b)
              px = ChunkyPNG::Color.compose_quick(px, bg_color)
            end
            if grayscale
              px = ChunkyPNG::Color.to_grayscale(px)
            end
            image.set_pixel(x, y, px)
          end
        end
      end

    end
  end
end
