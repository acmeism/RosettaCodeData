LEN = 3
GEN = 14
attr_reader :angle

def setup
  sketch_title 'Heighway Dragon'
  background(0, 0, 255)
  translate(170, 170)
  stroke(255)
  @angle = 90.radians
  turn_left(GEN)
end

def draw_line
  line(0, 0, 0, -LEN)
  translate(0, -LEN)
end

def turn_right(gen)
  return draw_line if gen.zero?

  turn_left(gen - 1)
  rotate(angle)
  turn_right(gen - 1)
end

def turn_left(gen)
  return draw_line if gen.zero?

  turn_left(gen - 1)
  rotate(-angle)
  turn_right(gen - 1)
end

def settings
  size(700, 600)
end
