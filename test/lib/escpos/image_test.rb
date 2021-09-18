require_relative '../../test_helper'

class ImageTest < Minitest::Test

  def setup
    @printer = Escpos::Printer.new
  end

  def test_image
    image_path = File.join(__dir__, '../../fixtures/tux_mono.png')
    image_file = File.new image_path
    image = Escpos::Image.new image_file,
      processor: "MiniMagick"
    image_file.close

    @printer << image
    @printer << "\n" * 10
    @printer.cut!
    image.processor.image.write(File.join(__dir__, "../../results/#{__method__}.png"))
    file = File.join(__dir__, "../../results/#{__method__}.txt")
    #@printer.save file

    assert_equal IO.binread(file), @printer.to_escpos
  end

  def test_image_conversion
    image_path = File.join(__dir__, '../../fixtures/tux_alpha.png')
    image = Escpos::Image.new image_path, grayscale: true,
      compose_alpha: true, extent: true,
      processor: "ChunkyPng"

    @printer << image.to_escpos
    @printer << "\n" * 10
    @printer.cut!
    image.processor.image.metadata = {}
    image.processor.image.save(File.join(__dir__, "../../results/#{__method__}.png"))
    file = File.join(__dir__, "../../results/#{__method__}.txt")
    #@printer.save file

    assert_equal IO.binread(file), @printer.to_escpos
  end

  def test_default_processor_klass
    image_path = File.join(__dir__, '../../fixtures/tux_alpha.png')
    image = Escpos::Image.new image_path, grayscale: true,
                              compose_alpha: true, extent: true
    assert_equal image.processor.class, Escpos::ImageProcessors::MiniMagick
  end
end
