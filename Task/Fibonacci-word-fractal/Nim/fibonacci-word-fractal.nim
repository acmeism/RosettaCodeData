import imageman

const
  Width = 1000
  Height = 1000
  LineColor = ColorRGBU [byte 64, 192, 96]
  Output = "fibword.png"


proc fibword(n: int): string =
  ## Return the nth fibword.
  var a = "1"
  result = "0"
  for _ in 1..n:
    a = result & a
    swap a, result


proc drawFractal(image: var Image; fw: string) =
  # Draw the fractal.
  var
    x = 0
    y = image.h - 1
    dx = 1
    dy = 0

  for i, ch in fw:
    let (nextx, nexty) = (x + dx, y + dy)
    image.drawLine((x, y), (nextx, nexty), LineColor)
    (x, y) = (nextx, nexty)
    if ch == '0':
      if (i and 1) == 0:
        (dx, dy) = (dy, -dx)
      else:
        (dx, dy) = (-dy, dx)


#———————————————————————————————————————————————————————————————————————————————————————————————————

var image = initImage[ColorRGBU](Width, Height)
image.fill(ColorRGBU [byte 0, 0, 0])
image.drawFractal(fibword(23))

# Save into a PNG file.
image.savePNG(Output, compression = 9)
