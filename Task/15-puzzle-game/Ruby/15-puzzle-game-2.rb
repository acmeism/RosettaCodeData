DIM = 100
SOLUTION = %w[1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 0].freeze

attr_reader :bcolor, :dark, :light, :tcolor, :space, :blank, :list

def settings
  size(400, 400)
end

def setup
  sketch_title 'Fifteen Tile Puzzle'
  labels = SOLUTION.shuffle
  @list = []
  grid(width, height, DIM, DIM) do |y, x|
    list << Tile.new(Vec2D.new(x, y), labels[list.length])
  end
  @tcolor = color(255, 175, 0)
  @bcolor = color(235, 231, 178)
  @dark = color(206, 141, 0)
  @light = color(255, 214, 126)
  text_size(DIM / 2.7)
  text_align(CENTER)
  no_loop
end

def draw
  list.each(&:draw)
end

def mouse_clicked
  inside = list.find_index { |tile| tile.include?(Vec2D.new(mouse_x, mouse_y)) }
  target = list.find_index { |tile| tile.label == '0' }
  source = list[inside].pos
  dest = list[target].pos
  return unless source.dist(dest) == DIM

  list[target].label = list[inside].label
  list[inside].label = '0'
  redraw
end

# Our Tile Boundary Class
class Boundary
  attr_reader :low, :high

  def initialize(low, high)
    @low = low
    @high = high
  end

  def include?(val)
    return false unless (low.x...high.x).cover? val.x

    return false unless (low.y...high.y).cover? val.y

    true
  end
end

# Holds Tile logic and draw (Processing::Proxy give access to Sketch methods)
class Tile
  include Processing::Proxy
  attr_writer :label
  attr_reader :boundary, :label, :pos

  def initialize(pos, lbl)
    @label = lbl
    @pos = pos
    @boundary = Boundary.new(pos, pos + Vec2D.new(DIM, DIM))
  end

  def draw_empty
    fill(bcolor)
    rect(pos.x + 1, pos.y + 1, DIM - 1, DIM - 1)
  end

  def draw_tile
    rect(pos.x + 1, pos.y + 1, DIM - 1, DIM - 1)
    fill(0) # Black text shadow
    text(label, pos.x + DIM / 2 + 1, pos.y + DIM / 2 + text_ascent / 2)
    fill(255)
    text(label, pos.x + DIM / 2, pos.y + DIM / 2 + text_ascent / 2)
    stroke(dark)
    line(pos.x + DIM - 1, pos.y + 1, pos.x + DIM - 1, pos.y + DIM - 2) # Right side shadow
    line(pos.x + 2, pos.y + DIM, pos.x + DIM - 1, pos.y + DIM - 2) # Bottom side shadow
    stroke(light)
    line(pos.x + 2, pos.y - 1, pos.x + 2, pos.y + DIM - 1) # Left bright
    line(pos.x + 2, pos.y + 1, pos.x + DIM - 1, pos.y + 1) # Upper bright
  end

  def include?(vec)
    boundary.include?(vec)
  end

  def draw
    no_stroke
    return draw_empty if label == '0'

    fill(tcolor)
    draw_tile
  end
end
