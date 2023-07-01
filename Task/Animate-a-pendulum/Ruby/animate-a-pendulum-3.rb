#!/bin/ruby

begin; require 'rubygems'; rescue; end

require 'gosu'
include Gosu

# Screen size
W = 640
H = 480

# Full-screen mode
FS = false

# Screen update rate (Hz)
FPS = 60

class Pendulum

  attr_accessor :theta, :friction

  def initialize( win, x, y, length, radius, bob = true, friction = false)
    @win = win
    @centerX = x
    @centerY = y
    @length = length
    @radius = radius
    @bob = bob
    @friction = friction

    @theta = 60.0
    @omega = 0.0
    @scale = 2.0 / FPS
  end

  def draw
    @win.translate(@centerX, @centerY) {
      @win.rotate(@theta) {
        @win.draw_quad(-1, 0, 0x3F_FF_FF_FF, 1, 0, 0x3F_FF_FF_00, 1, @length, 0x3F_FF_FF_00, -1, @length, 0x3F_FF_FF_FF )
        if @bob
          @win.translate(0, @length) {
            @win.draw_quad(0, -@radius, Color::RED, @radius, 0, Color::BLUE, 0, @radius, Color::WHITE, -@radius, 0, Color::BLUE )
          }
        end
      }
    }
  end

  def update
    # Thanks to Hugo Elias for the formula (and explanation thereof)
    @theta += @omega
    @omega = @omega - (Math.sin(@theta * Math::PI / 180) / (@length * @scale))
    @theta *= 0.999 if @friction
  end

end # Pendulum class

class GfxWindow < Window

  def initialize
    # Initialize the base class
    super W, H, FS, 1.0 / FPS * 1000
    # self.caption = "You're getting sleeeeepy..."
    self.caption = "Ruby/Gosu Pendulum Simulator (Space toggles friction)"

    @n = 1  # Try changing this number!
    @pendulums = []
    (1..@n).each do |i|
      @pendulums.push Pendulum.new( self, W / 2, H / 10, H * 0.75 * (i / @n.to_f), H / 60 )
    end

  end

  def draw
    @pendulums.each { |pen| pen.draw }
  end

  def update
    @pendulums.each { |pen| pen.update }
  end

  def button_up(id)
    if id == KbSpace
      @pendulums.each { |pen|
        pen.friction = !pen.friction
        pen.theta = (pen.theta <=> 0) * 45.0 unless pen.friction
      }
    else
      close
    end
  end

  def needs_cursor?()
    true
  end

end # GfxWindow class

begin
  GfxWindow.new.show
rescue Exception => e
  puts e.message, e.backtrace
  gets
end
