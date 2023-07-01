require 'cf3'

INV_SQRT = 1 / Math.sqrt(2)

def setup_the_dragon
  @dragon = ContextFree.define do
    shape :start do
      dragon alpha: 1
    end

    shape :dragon do
      square hue: 0, brightness: 0, saturation: 1, alpha: 0.02
      split do
        dragon size: INV_SQRT, rotation: -45, x: 0.25, y: 0.25
        rewind
        dragon size: INV_SQRT, rotation: 135, x: 0.25, y: 0.25
        rewind
      end
    end
  end
end

def settings
  size 800, 500
end

def setup
  sketch_title 'Heighway Dragon'
  setup_the_dragon
  draw_it
end

def draw_it
  background 255
  @dragon.render :start, size: width * 0.8, stop_size: 2,
                         start_x: width / 3, start_y: height / 3.5
end
