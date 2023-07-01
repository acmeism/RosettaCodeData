THETA = Math::PI * 2 / 5
SCALE_FACTOR = (3 - Math.sqrt(5)) / 2
MARGIN = 20

attr_reader :pentagons, :renderer
def settings
  size(400, 400)
end

def setup
  sketch_title 'Pentaflake'
  radius = width / 2 - 2 * MARGIN
  center = Vec2D.new(radius - 2 * MARGIN, 3 * MARGIN)
  pentaflake = Pentaflake.new(center, radius, 5)
  @pentagons = pentaflake.pentagons
end

def draw
  background(255)
  stroke(0)
  pentagons.each do |penta|
    draw_pentagon(penta)
  end
  no_loop
end

def draw_pentagon(pent)
  points = pent.vertices
  begin_shape
  points.each do |pnt|
    pnt.to_vertex(renderer)
  end
  end_shape(CLOSE)
end

def renderer
  @renderer ||= GfxRender.new(self.g)
end


class Pentaflake
  attr_reader :pentagons

  def initialize(center, radius, depth)
    @pentagons = []
    create_pentagons(center, radius, depth)
  end

  def create_pentagons(center, radius, depth)
    if depth.zero?
      pentagons << Pentagon.new(center, radius)
    else
      radius *= SCALE_FACTOR
      distance = radius * Math.sin(THETA) * 2
      (0..4).each do |idx|
        x = center.x + Math.cos(idx * THETA) * distance
        y = center.y + Math.sin(idx * THETA) * distance
        center = Vec2D.new(x, y)
        create_pentagons(center, radius, depth - 1)
      end
    end
  end
end

class Pentagon
  attr_reader :center, :radius

  def initialize(center, radius)
    @center = center
    @radius = radius
  end

  def vertices
    (0..4).map do |idx|
      center + Vec2D.new(radius * Math.sin(THETA * idx), radius * Math.cos(THETA * idx))
    end
  end
end
