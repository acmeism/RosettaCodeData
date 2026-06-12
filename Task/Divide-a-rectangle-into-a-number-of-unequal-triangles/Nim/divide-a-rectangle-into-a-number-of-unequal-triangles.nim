#[
  A rectangle is defined by its width "w" and its height "h".
  Its points have coordinates (0, 0), (w, 0), (w, h) and (0, h).

  To divide the rectangle in "n" triangles, we start by drawing the diagonal from (0, 0)
  to (w, h) which splits the rectangle into two triangles. The bottom triangle will be
  the last one. We build the "n - 1" other triangles by dividing the top side of the
  top triangle and drawing triangles starting from the origin.

  The leftmost triangle has a right angle, the other ones have an obtuse angle. It is obvious
  that all obtuse angles are different (their value increases with the x-coordinates of the
  top side). So none of these triangles are similar.

  The leftmost and the bottom triangles have both a right angle. They will be similar if their
  sides are proportional. For the bottom triangle the sides adjacent to the right angle have
  length "w" and "h". For the leftmost triangle, the left side has length "h". Let "d1" be the
  length of the top side. Of course "d1 < w". So the triangles will be similar if and only if
  "w / h = h / d1". if this is the case, we will modify "d1" and adjust the common length of
  the other triangles.
]#


import std/[lenientops, math, strformat]

type
  Point = tuple[x, y: float]
  Triangle = tuple[a, b, c: Point]
  Rectangle = tuple[w, h: float]


proc divide(rect: Rectangle; n: Positive): seq[Triangle] =
  ## Divide rectangle "rect" into "n" triangles.
  doAssert n >= 3, "Cannot cut rectangle into less than three triangles."

  const Origin: Point = (0, 0)

  # Cut the top triangle into "n - 1" triangles with a vertex at the
  # origin and an edge on the top side on the rectangle.

  # Divide the width in "n - 1" equal parts.
  var d = rect.w / (n - 1)  # Common length of edges.
  var d1 = d                # Length of the edge for the leftmost triangle.

  # Make sure that the leftmost triangle is not similar to the first triangle.
  # As "d1 < rect.w", this would be the case if the edge length "d1" is such
  # that "rect.w / rect.h = rect.h / d1".
  if rect.w * d1 == rect.h * rect.h:
    # Adjust "d1" and "d".
    d1 += 1
    d = (rect.w - d1) / (n - 2)

  # Add the leftmost triangle.
  result.add (Origin, (d1, rect.h), (0.0, rect.h))

  # Add other triangles except the rightmost one to make up for rounding errors.
  var x = d1
  for _ in 1..(n - 3):
    let nextx = x + d
    result.add (Origin, (nextx, rect.h), (x, rect.h))
    x = nextx

  # Add the rightmost triangle.
  result.add (Origin, (rect.w, rect.h), (x, rect.h))

  # Finally, add the bottom triangle.
  result.add (Origin, (rect.w, 0.0), (rect.w, rect.h))


proc `$`(p: Point): string =
  ## String representation of a Point.
  &"({p.x}, {p.y})"

proc `$`(t: Triangle): string =
  ## String representation of a Triangle.
  &"[{t.a}, {t.b}, {t.c}]"

proc `$`(r: Rectangle): string =
  ## String representation of a Rectangle.
  &"[(0.0, 0.0), ({r.w}, 0.0), ({r.w}, {r.h}), (0.0, {r.h})]"


when isMainModule:
  let rect = (w: 400.0, h: 300.0)
  echo &"Cutting rectangle {rect} into 9 triangles:"
  let triangles = rect.divide(9)
  for triangle in triangles:
    echo "  ", triangle

  # Draw the triangles.

  import cairo

  type Color = array[3, float]

  const Colors: array[3, Color] = [[1.0, 0.0, 0.0], [0.0, 1.0, 0.0], [0.0, 0.0, 1.0]]

  proc setColor(ctx: ptr Context; color: Color) =
    ctx.setSourceRgb(color[0], color[1], color[2])


  let surface = imageSurfaceCreate(FormatRgb24, rect.w.int32, rect.h.int32)
  let context = create(surface)

  for i, triangle in triangles:
    context.setColor(Colors[i mod 3])
    context.moveTo(triangle.a.x, rect.h - triangle.a.y)
    context.lineTo(triangle.b.x, rect.h - triangle.b.y)
    context.lineTo(triangle.c.x, rect.h - triangle.c.y)
    context.lineTo(triangle.a.x, rect.h - triangle.a.y)
    context.fill()

  if surface.writeToPng("divide_rect.png") != StatusSuccess:
    quit "Error while saving file.", QuitFailure
