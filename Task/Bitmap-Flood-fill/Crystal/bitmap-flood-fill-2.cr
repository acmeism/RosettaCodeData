require "./circle"
require "./flood_fill"
require "./write_ppm"
require "./load_ppm"

img = Pixmap.new 120, 80, Color::WHITE
img.circle 60, 40, 35, Color::BLACK
img.circle 100, 20, 18, Color::RED

img.flood_fill 10, 10, Color.new(210, 230, 0)
img.flood_fill 60, 40, Color.new(255, 128, 76)

img.write "crystal_flood_fill.ppm"


img = Pixmap.load "Unfilledcirc.ppm"
img.flood_fill 10, 10, Color.new(0, 128, 240)
img.flood_fill img.width-1, img.height-1, Color.new(0, 128, 240)
img.flood_fill 10, img.height//2, Color.new(240, 180, 10)
img.flood_fill 100, 100, Color.new(255, 60, 10)

img.write "crystal_filledcirc.ppm"
