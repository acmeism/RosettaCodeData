# frozen_string_literal: true

load_library :grammar
attr_reader :hilbert
def settings
  size 600, 600
end

def setup
  sketch_title '2D Hilbert'
  @hilbert = Hilbert.new
  hilbert.create_grammar 5
  no_loop
end

def draw
  background 0
  hilbert.render
end

Turtle = Struct.new(:x, :y, :theta)

# Hilbert Class has access to Sketch methods eg :line, :width, :height
class Hilbert
  include Processing::Proxy

  attr_reader :grammar, :axiom, :draw_length, :production, :turtle
  DELTA = 90.radians
  def initialize
    @axiom = 'FL'
    @grammar = Grammar.new(
      axiom,
      'L' => '+RF-LFL-FR+',
      'R' => '-LF+RFR+FL-'
    )
    @draw_length = 200
    stroke 0, 255, 0
    stroke_weight 2
    @turtle = Turtle.new(width / 9, height / 9, 0)
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
      when 'L'
      when 'R'
      else puts 'Grammar not recognized'
      end
    end
  end

  def draw_line(turtle)
    x_temp = turtle.x
    y_temp = turtle.y
    turtle.x += draw_length * Math.cos(turtle.theta)
    turtle.y += draw_length * Math.sin(turtle.theta)
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
