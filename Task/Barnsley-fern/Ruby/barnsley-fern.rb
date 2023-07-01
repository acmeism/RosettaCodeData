MAX_ITERATIONS = 200_000

def setup
  sketch_title 'Barnsley Fern'
  no_loop
  puts 'Be patient. This takes about 10 seconds to render.'
end

def draw
  background 0
  load_pixels
  x0 = 0.0
  y0 = 0.0
  x = 0.0
  y = 0.0
  MAX_ITERATIONS.times do
    r = rand(100)
    if r < 85
      x = 0.85 * x0 + 0.04 * y0
      y = -0.04 * x0 + 0.85 * y0 + 1.6
    elsif r < 92
      x = 0.2 * x0 - 0.26 * y0
      y = 0.23 * x0 + 0.22 * y0 + 1.6
    elsif r < 99
      x = -0.15 * x0 + 0.28 * y0
      y = 0.26 * x0 + 0.24 * y0 + 0.44
    else
      x = 0
      y = 0.16 * y
    end
    i = height - (y * 48).to_i
    j = width / 2 + (x * 48).to_i
    pixels[i * height + j] += 2_560
    x0 = x
    y0 = y
  end
  update_pixels
end

def settings
  size 500, 500
end
