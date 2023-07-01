import random
import imageman

const
  Size = 400                                  # Area size.
  MaxXY = Size - 1                            # Maximum possible value for x and y.
  NPart = 25_000                              # Number of particles.
  Background = ColorRGBU [byte 0, 0, 0]       # Background color.
  Foreground = ColorRGBU [byte 50, 150, 255]  # Foreground color.

randomize()
var image = initImage[ColorRGBU](Size, Size)
image.fill(Background)
image[Size div 2, Size div 2] = Foreground

for _ in 1..NPart:

  block ProcessParticle:
    while true:   # Repeat until the particle is freezed.

      # Choose position of particle.
      var x, y = rand(MaxXY)
      if image[x, y] == Foreground:
        continue  # Not free. Try again.

      # Move the particle.
      while true:

        # Choose a motion.
        let dx, dy = rand(-1..1)
        inc x, dx
        inc y, dy
        if x notin 0..MaxXY or y notin 0..MaxXY:
          break  # Out of limits. Try again.

        # Valid move.
        if image[x, y] == Foreground:
          # Not free. Freeze the particle at its previous position.
          image[x - dx, y - dy] = Foreground
          break ProcessParticle   # Done. Process next particle.

# Save into a PNG file.
image.savePNG("brownian.png", compression = 9)
