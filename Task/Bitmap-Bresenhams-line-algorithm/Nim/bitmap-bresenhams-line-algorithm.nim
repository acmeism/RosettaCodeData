import math

proc line(img: var Image, p, q: Point) =
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
    img[p] = Black
    if p == q:
      break
    e2 = err
    if e2 > -dx:
      err -= dy
      p.x += sx
    if e2 < dy:
      err += dx
      p.y += sy
