import random
import imageman

const Size = 500

randomize()
var image = initImage[ColorRGBU](Size, Size)
for x in 0..<Size:
  for y in 0..<Size:
    let color = ColorRGBU([rand(255).byte, rand(255).byte, rand(255).byte])
    image[x, y] = color

image.savePNG("prng_image.png", compression = 9)
