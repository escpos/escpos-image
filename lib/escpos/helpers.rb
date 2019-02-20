module Escpos
  module Helpers

    def image(path, options = {})
      Image.new(path, options).to_escpos
    end

  end
end
