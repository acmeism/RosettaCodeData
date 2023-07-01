# frozen_string_literal: true

attr_reader :max_iter
CONST = Complex(-0.7, 0.27015)

def setup
  sketch_title 'Julia Set'
  @max_iter = 360
  color_mode HSB, 360, 100, 100
  load_pixels
end

def draw
  grid(width, height) do |x, y|
    i = max_iter
    z = Complex(map1d(x, 0..width, -1.4..1.4), map1d(y, 0..height, -1.0..1.0))
    while z.abs < 2 && i -= 1
      z *= z
      z += CONST
    end
    pixels[x + width * y] = color((360 * i) / max_iter, 100, i)
  end
  update_pixels
  fill 0
  text CONST.to_s, 530, 400
  no_loop
end
