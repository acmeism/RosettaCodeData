load_libraries :grammar
attr_reader :points

def setup
  sketch_title 'Sierpinski Arrowhead'
  sierpinski = SierpinskiArrowhead.new(Vec2D.new(width * 0.15, height * 0.7))
  production = sierpinski.generate 6 # 6 generations looks OK
  @points = sierpinski.translate_rules(production)
  no_loop
end

def draw
  background(0)
  render points
end

def render(points)
  no_fill
  stroke 200.0
  stroke_weight 3
  begin_shape
  points.each_slice(2) do |v0, v1|
    v0.to_vertex(renderer)
    v1.to_vertex(renderer)
  end
  end_shape
end

def renderer
  @renderer ||= GfxRender.new(g)
end

def settings
  size(800, 800)
end

# SierpinskiArrowhead class
class SierpinskiArrowhead
  include Processing::Proxy
  attr_reader :draw_length, :pos, :theta, :axiom, :grammar
  DELTA = PI / 3 # 60 degrees
  def initialize(pos)
    @axiom = 'XF' # Axiom
    rules = {
      'X' => 'YF+XF+Y',
      'Y' => 'XF-YF-X'
    }
    @grammar = Grammar.new(axiom, rules)
    @theta = 0
    @draw_length = 200
    @pos = pos
  end

  def generate(gen)
    @draw_length = draw_length * 0.6**gen
    grammar.generate gen
  end

  def forward(pos)
    pos + Vec2D.from_angle(theta) * draw_length
  end

  def translate_rules(prod)
    [].tap do |pts| # An array to store line vertices as Vec2D
      prod.scan(/./) do |ch|
        case ch
        when 'F'
          new_pos = forward(pos)
          pts << pos << new_pos
          @pos = new_pos
        when '+'
          @theta += DELTA
        when '-'
          @theta -= DELTA
        when 'X', 'Y'
        else
          puts("character #{ch} not in grammar")
        end
      end
    end
  end
end
