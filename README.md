# Escpos-image

A ruby implementation of ESC/POS (thermal) printer image command specification.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'escpos-image'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install escpos-image

## Examples

![](https://github.com/escpos/escpos-image/blob/master/examples/IMG_20160610_232415_HDR.jpg)

## Usage

```ruby
@printer = Escpos::Printer.new
image = Escpos::Image.new 'path/to/image.png'

# Recommended usage for best results:
# Supports all mini_magick formats
# Converts the image to monochrome, applies dithering and blends alpha
# Requires the mini_magick gem installed
image = Escpos::Image.new 'path/to/image.png', {
  convert_to_monochrome: true,
  dither: true, # default
  extent: true, # default
}

# Alternative usage:
# Supports only PNG images
# Does NOT require the mini_magick gem installed
image = Escpos::Image.new 'path/to/image.png', {
  compose_alpha: true, # default
  compose_alpha_bg: 255, # default, assumes white background
}

@printer.write image.to_escpos

@printer.to_escpos # returns ESC/POS data ready to be sent to printer
# on linux this can be piped directly to /dev/usb/lp0
# with network printer sent directly to printer socket
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/escpos/escpos-image.

1. Fork it ( https://github.com/escpos/escpos-image/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
