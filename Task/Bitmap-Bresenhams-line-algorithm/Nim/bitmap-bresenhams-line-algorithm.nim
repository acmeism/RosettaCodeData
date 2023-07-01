import bitmap

proc drawLine*(img: Image; p, q: Point; color: Color) =
  let
    dx = abs(q.x - p.x)
    sx = if p.x < q.x: 1 else: -1
    dy = abs(q.y - p.y)
    sy = if p.y < q.y: 1 else: -1

  var
    p = p
    q = q
    err = (if dx > dy: dx else: -dy) div 2
    e2 = 0

  while true:
    img[p.x, p.y] = color
    if p == q:
      break
    e2 = err
    if e2 > -dx:
      err -= dy
      p.x += sx
    if e2 < dy:
      err += dx
      p.y += sy

when isMainModule:
  var img = newImage(16, 16)
  img.fill(White)
  img.drawLine((0, 7), (7, 15), Black)
  img.drawLine((7, 15), (15, 7), Black)
  img.drawLine((15, 7), (7, 0), Black)
  img.drawLine((7, 0), (0, 7), Black)
  img.print()
