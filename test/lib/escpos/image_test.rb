require_relative '../../test_helper'

class ImageTest < Minitest::Test
  def setup
    @printer = Escpos::Printer.new
  end

  def test_image
    image_path = File.join(__dir__, '../../fixtures/tux_mono.png')
    image = Escpos::Image.new image_path

    @printer << image
    @printer << "\n" * 10
    @printer.cut!
    image.chunky_png_image.metadata = {}
    image.chunky_png_image.save(File.join(__dir__, "../../results/#{__method__}.png"))
    file = File.join(__dir__, "../../results/#{__method__}.txt")
    #IO.binwrite file, @printer.to_escpos
    assert_equal IO.binread(file), @printer.to_escpos
  end

  def test_image_conversion
    image_path = File.join(__dir__, '../../fixtures/tux_alpha.png')
    image = Escpos::Image.new image_path, grayscale: true,
      compose_alpha: true, extent: true

    @printer << image.to_escpos
    @printer << "\n" * 10
    @printer.cut!
    image.chunky_png_image.metadata = {}
    image.chunky_png_image.save(File.join(__dir__, "../../results/#{__method__}.png"))
    file = File.join(__dir__, "../../results/#{__method__}.txt")
    #IO.binwrite file, @printer.to_escpos
    assert_equal IO.binread(file), @printer.to_escpos
  end

end
