import random
import imageman

randomize()

# Build a color table.
var colors: array[256, ColorRGBU]
for color in colors.mitems:
  color = ColorRGBU [byte rand(255), byte rand(255), byte rand(255)]


var image = initImage[ColorRGBU](256, 256)

for i in 0..255:
  for j in 0..255:
    image[i, j] = colors[i xor j]

image.savePNG("munching_squares.png")
