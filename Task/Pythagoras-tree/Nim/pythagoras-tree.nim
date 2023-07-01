import imageman

const
  Width = 1920
  Height = 1080
  MaxDepth = 10
  Color = ColorRGBU([byte 0, 255, 0])


proc drawTree(img: var Image; x1, y1, x2, y2: int; depth: Natural) =

  if depth == 0: return

  let
    dx = x2 - x1
    dy = y1 - y2
    x3 = x2 - dy
    y3 = y2 - dx
    x4 = x1 - dy
    y4 = y1 - dx
    x5 = x4 + (dx - dy) div 2
    y5 = y4 - (dx + dy) div 2

  # Draw square.
  img.drawPolyline(true, Color, (x1, y1), (x2, y2), (x3, y3), (x4, y4))

  # Draw triangle.
  img.drawPolyline(true, Color, (x3, y3), (x4, y4), (x5, y5))

  # Next level.
  img.drawTree(x4, y4, x5, y5, depth - 1)
  img.drawTree(x5, y5, x3, y3, depth - 1)


var image = initImage[ColorRGBU](Width, Height)
image.drawTree(int(Width / 2.3), Height - 1, int(Width / 1.8), Height - 1, MaxDepth)
image.savePNG("pythagoras_tree.png", compression = 9)
