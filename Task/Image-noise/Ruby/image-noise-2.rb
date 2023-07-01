PALLETE = %w[#000000 #FFFFFF]
attr_reader :black, :dim, :white
def settings
  size(320, 240)
end

def setup
  sketch_title 'Image Noise'
  @black = color(PALLETE[0])
  @white = color(PALLETE[1])
  @dim = width * height
  load_pixels
end

def draw
  dim.times { |idx| pixels[idx] = (rand < 0.5) ? black : white }
  update_pixels
  fill(0, 128)
  rect(0, 0, 60, 20)
  fill(255)
  text(frame_rate, 5, 15)
end
