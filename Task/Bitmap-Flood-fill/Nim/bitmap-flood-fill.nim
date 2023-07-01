import bitmap

proc floodFill*(img: Image; initPoint: Point; targetColor, replaceColor: Color) =

  var stack: seq[Point]
  let width = img.w
  let height = img.h

  if img[initPoint.x, initPoint.y] != targetColor:
    return

  stack.add(initPoint)

  while stack.len > 0:
    var w, e: Point
    let pt = stack.pop()
    if img[pt.x, pt.y] == targetColor:
      w = pt
      e = if pt.x + 1 < width: (pt.x + 1, pt.y) else: pt
    else:
      continue  # Already processed.

    # Move west until color of node does not match "targetColor".
    while w.x >= 0 and img[w.x, w.y] == targetColor:
      img[w.x, w.y] = replaceColor
      if w.y + 1 < height and img[w.x, w.y + 1] == targetColor:
        stack.add((w.x, w.y + 1))
      if w.y - 1 >= 0 and img[w.x, w.y - 1] == targetColor:
        stack.add((w.x, w.y - 1))
      dec w.x

    # Move east until color of node does not match "targetColor".
    while e.x < width and img[e.x, e.y] == targetColor:
      img[e.x, e.y] = replaceColor
      if e.y + 1 < height and img[e.x, e.y + 1] == targetColor:
        stack.add((e.x, e.y + 1))
      if e.y - 1 >= 0 and img[e.x, e.y - 1] == targetColor:
        stack.add((e.x, e.y - 1))
      inc e.x

#———————————————————————————————————————————————————————————————————————————————————————————————————

when isMainModule:

  import ppm_read, ppm_write

  var img = readPPM("Unfilledcirc.ppm")
  img.floodFill((30, 122), White, color(255, 0, 0))
  img.writePPM("Unfilledcirc_red.ppm")
