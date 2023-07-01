import math
import imageman

const
  ## Separation of the two endpoints.
  ## Make this a power of 2 for prettier output.
  Sep = 512
  ## Depth of recursion. Adjust as desired for different visual effects.
  Depth = 18

  S = sqrt(2.0) / 2
  Sin = [float 0, S, 1, S, 0, -S, -1, -S]
  Cos = [float 1, S, 0, -S, -1, -S, 0, S]

  LineColor = ColorRGBU [byte 64, 192, 96]
  Width = Sep * 11 div 6
  Height = Sep * 4 div 3

  Output = "dragon.png"

#---------------------------------------------------------------------------------------------------

func dragon(img: var Image; n, a, t: int; d, x, y: float) =
  if n <= 1:
    img.drawLine((x.toInt, y.toInt), ((x + d * Cos[a]).toInt, (y + d * Sin[a]).toInt), LineColor)
    return
  let d = d * S
  let a1 = (a - t) and 7
  let a2 = (a + t) and 7
  img.dragon(n - 1, a1, 1, d, x, y)
  img.dragon(n - 1, a2, -1, d, x + d * Cos[a1], y + d * Sin[a1])

#---------------------------------------------------------------------------------------------------

var image = initImage[ColorRGBU](Width, Height)
image.fill(ColorRGBU [byte 0, 0, 0])
image.dragon(Depth, 0, 1, Sep, Sep / 2, Sep * 5 / 6)

# Save into a PNG file.
image.savePNG(Output, compression = 9)
