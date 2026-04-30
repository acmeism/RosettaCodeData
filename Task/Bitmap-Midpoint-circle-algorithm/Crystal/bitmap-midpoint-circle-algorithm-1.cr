require "./pixmap"
require "./bresenham"

class Pixmap
  def circle (cx, cy, r, color, fill = false)
    f = 1 - r
    ddF_X = 0
    ddF_Y = -2 * r
    x = 0
    y = r
    self[cx, cy + r] = color
    self[cx, cy - r] = color
    p1, p2 = {cx + r, cy}, {cx - r, cy}
    if fill
      line(*p1, *p2, color)
    else
      self[*p1] = self[*p2] = color
    end
    while x < y
      if f >= 0
        y -= 1
        ddF_Y += 2
        f += ddF_Y
      end
      x += 1
      ddF_X += 2
      f += ddF_X + 1
      [{cx - x, cy - y}, {cx + x, cy - y},
       {cx - x, cy + y}, {cx + x, cy + y},
       {cx - y, cy - x}, {cx + y, cy - x},
       {cx - y, cy + x}, {cx + y, cy + x}].each_slice(2, reuse: true) do |(p1, p2)|
        if fill
          line(*p1, *p2, color)
        else
          self[*p1] = self[*p2] = color
        end
      end
    end
  end
end
