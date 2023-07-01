attr_reader :buffer, :palette, :r, :g, :b, :rd, :gd, :bd, :dim

def settings
  size(600, 600)
end

def setup
  sketch_title 'Plasma Effect'
  frame_rate 25
  @r = 42
  @g = 84
  @b = 126
  @rd = true
  @gd = true
  @bd = true
  @dim = width * height
  @buffer = Array.new(dim)
  grid(width, height) do |x, y|
    buffer[x + y * width] = (
      (
        (128 + (128 * sin(x / 32.0))) +
        (128 + (128 * cos(y / 32.0))) +
        (128 + (128 * sin(Math.hypot(x, y) / 32.0)))
      ) / 4
    ).to_i
  end
  load_pixels
end

def draw
  if rd
    @r -= 1
    @rd = false if r.negative?
  else
    @r += 1
    @rd = true if r > 128
  end
  if gd
    @g -= 1
    @gd = false if g.negative?
  else
    @g += 1
    @gd = true if g > 128
  end
  if bd
    @b -= 1
    @bd = false if b.negative?
  else
    @b += 1
    @bd = true if b > 128
  end
  @palette = (0..127).map do |col|
    s1 = sin(col * Math::PI / 25)
    s2 = sin(col * Math::PI / 50 + Math::PI / 4)
    color(r + s1 * 128, g + s2 * 128, b + s1 * 128)
  end
  dim.times do |idx|
    pixels[idx] = palette[(buffer[idx] + frame_count) & 127]
  end
  update_pixels
end
