#$VERBOSE = true

require 'minitest/autorun'
#require 'minitest/pride'
require 'pp'

require 'escpos'
require 'chunky_png'
require 'mini_magick'

require File.expand_path('../../lib/escpos/image.rb', __FILE__)
