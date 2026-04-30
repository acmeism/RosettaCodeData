require "./bresenham"

img = Pixmap.new 10, 5, Color::WHITE

img.line 0, 3, 9, 0, Color::RED

img.write STDOUT
