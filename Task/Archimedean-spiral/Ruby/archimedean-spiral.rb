INCR = 0.1
attr_reader :x, :theta

def setup
  sketch_title 'Archimedian Spiral'
  @theta = 0
  @x = 0
  background(255)
  translate(width / 2.0, height / 2.0)
  begin_shape
  (0..50*PI).step(INCR) do |theta|
    @x = theta * cos(theta / PI)
    curve_vertex(x, theta * sin(theta / PI))
  end
  end_shape
end

def settings
  size(300, 300)
end
