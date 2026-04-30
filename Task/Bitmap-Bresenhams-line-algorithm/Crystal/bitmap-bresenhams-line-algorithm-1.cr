require "./pixmap"

class Pixmap
  def line (x0, y0, x1, y1, color)
    dx, sx = (x1-x0).abs, x0<x1 ? 1 : -1
    dy, sy = (y1-y0).abs, y0<y1 ? 1 : -1
    err = (dx>dy ? dx : -dy) // 2

    loop do
      self[x0, y0] = color
      break if x0 == x1 && y0 == y1
      e2 = err
      (err -= dy; x0 += sx) if e2 >-dx
      (err += dx; y0 += sy) if e2 < dy
    end
  end
end
