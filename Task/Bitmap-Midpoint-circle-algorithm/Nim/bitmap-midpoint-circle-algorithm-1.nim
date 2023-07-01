import bitmap

proc setPixel(img: Image; x, y: int; color: Color) {.inline.} =
  # Set a pixel at a given color.
  # Ignore if the point is outside of the image.
  if x in 0..<img.w and y in 0..<img.h:
    img[x, y] = color


proc drawCircle(img: Image; center: Point; radius: Natural; color: Color) =
  ## Draw a circle using midpoint circle algorithm.

  var
    f = 1 - radius
    ddFX = 0
    ddFY = -2 * radius
    x = 0
    y = radius

  img.setPixel(center.x, center.y + radius, color)
  img.setPixel(center.x, center.y - radius, color)
  img.setPixel(center.x + radius, center.y, color)
  img.setPixel(center.x - radius, center.y, color)

  while x < y:
    if f >= 0:
      dec y
      inc ddFY, 2
      inc f, ddFY
    inc x
    inc ddFX, 2
    inc f, ddFX + 1

    img.setPixel(center.x + x, center.y + y, color)
    img.setPixel(center.x - x, center.y + y, color)
    img.setPixel(center.x + x, center.y - y, color)
    img.setPixel(center.x - x, center.y - y, color)
    img.setPixel(center.x + y, center.y + x, color)
    img.setPixel(center.x - y, center.y + x, color)
    img.setPixel(center.x + y, center.y - x, color)
    img.setPixel(center.x - y, center.y - x, color)

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:
  var img = newImage(16, 16)
  img.fill(White)
  img.drawCircle((7, 7), 5, Black)
  img.print()
