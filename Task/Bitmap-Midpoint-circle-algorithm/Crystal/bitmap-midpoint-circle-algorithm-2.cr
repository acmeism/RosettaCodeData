require "./circle"
require "./write_ppm"

img = Pixmap.new 100, 100, Color::WHITE

img.circle 50, 50, 40, Color::RED, true
img.circle 70, 60, 15, Color::BLUE, true
img.circle 40, 20, 20, Color::BLACK
img.circle 40, 20, 19, Color.new(255, 144, 0)
img.circle 40, 20, 18, Color::BLACK

img.write "crystal_circles.ppm"
