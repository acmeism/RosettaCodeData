def settings
  size(300, 300)
end

def setup
  sketch_title 'Color Wheel'
  background(0)
  radius = width / 2.0
  center = width / 2
  grid(width, height) do |x, y|
    rx = x - center
    ry = y - center
    sat = Math.hypot(rx, ry) / radius
    if sat <= 1.0
      hue = ((Math.atan2(ry, rx) / PI) + 1) / 2.0
      color_mode(HSB)
      col = color((hue * 255).to_i, (sat * 255).to_i, 255)
      set(x, y, col)
    end
  end
end
