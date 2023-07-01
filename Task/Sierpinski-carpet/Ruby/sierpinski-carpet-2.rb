attr_reader :limit

def setup
  sketch_title 'Sierpinski Carpet'
  n = 4
  @limit = width / 3**n
  fill 0
  background 255
  no_stroke
  holes(0, 0, width / 3)
end

def in_carpet?(xpos, ypos)
  !(xpos == 1 && ypos == 1)
end

def holes(xpos, ypos, dim)
  return if dim < limit

  grid(3, 3) do |row, col|
    offset_x = xpos + row * dim
    offset_y = ypos + col * dim
    rect(offset_x, offset_y, dim, dim) unless in_carpet?(row, col)
    holes(offset_x, offset_y, dim / 3)
  end
end

def settings
  size(729, 729)
end
