# frozen_string_literal: true

def setup
  sketch_title 'Pythagoras Tree'
  background(255)
  stroke(0, 255, 0)
  tree(width / 2.3, height, width / 1.8, height, 10)
end

def tree(x1, y1, x2, y2, depth)
  return if depth <= 0

  dx = (x2 - x1)
  dy = (y1 - y2)

  x3 = (x2 - dy)
  y3 = (y2 - dx)
  x4 = (x1 - dy)
  y4 = (y1 - dx)
  x5 = (x4 + 0.5 * (dx - dy))
  y5 = (y4 - 0.5 * (dx + dy))
  # square
  begin_shape
  fill(0.0, 255.0 / depth, 0.0)
  vertex(x1, y1)
  vertex(x2, y2)
  vertex(x3, y3)
  vertex(x4, y4)
  vertex(x1, y1)
  end_shape
  # triangle
  begin_shape
  fill(0.0, 255.0 / depth, 0.0)
  vertex(x3, y3)
  vertex(x4, y4)
  vertex(x5, y5)
  vertex(x3, y3)
  end_shape
  tree(x4, y4, x5, y5, depth - 1)
  tree(x5, y5, x3, y3, depth - 1)
end

def settings
  size(800, 400)
end
