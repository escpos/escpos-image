module Escpos
  module Helpers
    extend self

    def image(path, options = {})
      Image.new(path, options).to_escpos
    end

  end
end
