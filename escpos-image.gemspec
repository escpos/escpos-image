lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'escpos/image'

Gem::Specification.new do |spec|
  spec.name          = "escpos-image"
  spec.version       = Escpos::Image::VERSION
  spec.authors       = ["Jan Svoboda"]
  spec.email         = ["jan@mluv.cz"]
  spec.summary       = %q{A ruby implementation of ESC/POS (thermal) printer image command specification.}
  spec.description   = %q{A ruby implementation of ESC/POS (thermal) printer image command specification.}
  spec.homepage      = "https://github.com/escpos/escpos-image"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "minitest", "~> 5.4"
  spec.add_development_dependency "mini_magick"

  spec.add_dependency "escpos"
  spec.add_dependency "chunky_png"
end
