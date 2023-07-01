# frozen_string_literal: true

def setup
  sketch_title 'Mandelbrot'
  load_pixels
  no_loop
end

def draw
  grid(900, 600) do |x, y|
    const = Complex(
      map1d(x, (0...900), (-3..1.5)), map1d(y, (0...600), (-1.5..1.5))
    )
    pixels[x + y * 900] = color(
      constrained_map(mandel(const, 20), (5..20), (255..0))
    )
  end
  update_pixels
end

def mandel(z, max)
  score = 0
  const = z
  while score < max
    # z = z^2 + c
    z *= z
    z += const
    break if z.abs > 2

    score += 1
  end
  score
end

def settings
  size(900, 600)
end
