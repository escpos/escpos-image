module Escpos
  module Helpers

    def image(path, opts = {})
      Image.new(path, opts).to_escpos
    end

  end
end
