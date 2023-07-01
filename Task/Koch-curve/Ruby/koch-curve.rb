attr_reader :koch
def settings
  size 600, 600
end

def setup
  sketch_title '2D Koch'
  @koch = KochSnowflake.new
  koch.create_grammar 5
  no_loop
end

def draw
  background 0
  koch.render
end

# LSystem class
class Grammar
  attr_reader :axiom, :rules
  def initialize(axiom, rules)
    @axiom = axiom
    @rules = rules
  end

  def apply_rules(prod)
    prod.gsub(/./) { |token| rules.fetch(token, token) }
  end

  def generate(gen)
    return axiom if gen.zero?

    prod = axiom
    gen.times do
      prod = apply_rules(prod)
    end
    prod
  end
end

Turtle = Struct.new(:x, :y, :theta)

# KochSnowflake class has access to Sketch methods eg :line, :width, :height
class KochSnowflake
  include Processing::Proxy

  attr_reader :grammar, :axiom, :draw_length, :production, :turtle
  DELTA = 60.radians

  def initialize
    @axiom = 'F--F--F' # 'F' for simple Koch Curve
    @grammar = Grammar.new(
      axiom,
      'F' => 'F+F--F+F'
    )
    @draw_length = 20
    stroke 0, 255, 0
    stroke_weight 2
    @turtle = Turtle.new(width / 5, height * 0.7, 0)
  end

  def render
    production.scan(/./) do |element|
      case element
      when 'F' # NB NOT using affine transforms
        draw_line(turtle)
      when '+'
        turtle.theta += DELTA
      when '-'
        turtle.theta -= DELTA
      when 'L', 'R'
      else puts 'Grammar not recognized'
      end
    end
  end

  def draw_line(turtle)
    x_temp = turtle.x
    y_temp = turtle.y
    @turtle.x += draw_length * Math.cos(turtle.theta)
    @turtle.y += draw_length * Math.sin(turtle.theta)
    line(x_temp, y_temp, turtle.x, turtle.y)
  end

  ##############################
  # create grammar from axiom and
  # rules (adjust scale)
  ##############################

  def create_grammar(gen)
    @draw_length *= 0.6**gen
    @production = @grammar.generate gen
  end
end
