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

# Creating image from path
image = Escpos::Image.new 'path/to/image.png', {
  processor: "ChunkyPng" # default or MiniMagick
  # ... other options, see following sections
}

# The MiniMagick processor requires the mini_magick gem installed

# The constructor also accepts an instance of ChunkyPNG::Image or MiniMagick::Image

@printer << image

@printer.to_escpos # returns ESC/POS data ready to be sent to printer
# on linux this can be piped directly to /dev/usb/lp0
# with network printer sent directly to printer socket
# with serial port printer it can be sent directly to the serial port

@printer.to_base64 # returns base64 encoded ESC/POS data
```

## Supported  formats

| ChunkyPng | MiniMagick |
| --- | --- |
| PNG | PNG, JPG, BMP, ... (everything supported by MiniMagick) |

When using MiniMagick processor, `mini_magick` gem has to be installed or added to the Gemfile, this makes the gem more lightweight by making this dependency optional.

## Image manipulation

All options in the following section are optional and opt-in. By default we only take the RGB value from each pixel, average the sum of the components and make the resulting pixel black if the average is under or equal to 128 and white if it is 129 and up.

## Supported options

| Option | ChunkyPng | MiniMagick | Possible values | Default | Description |
| --- | :---: | :---: | --- | --- | --- |
| dither | ❌ | ✅ | true/false | false | Apply [dithering](https://en.wikipedia.org/wiki/Dither) to the image |
| rotate | ❌ | ✅ | String | none | Apply rotation, accepts any MiniMagick valid string |
| resize | ❌ | ✅ | String | none | Apply resize, accepts any MiniMagick valid string |
| grayscale | ✅ | ✅ | true/false | false | Convert image to grayscale (mimics the relative perceptual RGB color sensitivity of the human eye) |
| extent | ✅ | ✅ | true/false | false | Scale the image to nice round dimensions divisible by 8 (required unless input image meets it) |
| compose_alpha | ✅ | ✅ | true/false | false | Blend alpha into the image (assumes white background by default) |
| compose_alpha_bg_r | ✅ | ✅ | 0-255 | 255 | Value of the red component of the background when blending alpha |
| compose_alpha_bg_g | ✅ | ✅ | 0-255 | 255 | Value of the green component of the background when blending alpha |
| compose_alpha_bg_b | ✅ | ✅ | 0-255 | 255 | Value of the blue component of the background when blending alpha |

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/escpos/escpos-image.

1. Fork it ( https://github.com/escpos/escpos-image/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
