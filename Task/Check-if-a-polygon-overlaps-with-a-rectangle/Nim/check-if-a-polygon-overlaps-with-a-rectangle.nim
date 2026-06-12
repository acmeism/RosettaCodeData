type
  Vector2 = (float, float)
  Projection = tuple[min, max: float]
  Polygon = seq[Vector2]
  Rectangle = tuple[x, y, w, h: float]

func dot(v1, v2: Vector2): float =
  v1[0] * v2[0] + v1[1] * v2[1]

func axes(poly: Polygon): seq[Vector2] =
  result.setLen(poly.len)
  for i, vertex1 in poly:
    let vertex2 = poly[if i + 1 == poly.len: 0 else: i + 1]
    let edge = (vertex1[0] - vertex2[0], vertex1[1] - vertex2[1])
    result[i] = (-edge[1], edge[0])

func projectionOnAxis(poly: Polygon; axis: Vector2): Projection =
  result.min = Inf
  result.max = -Inf
  for vertex in poly:
    let p = axis.dot(vertex)
    if p < result.min:
      result.min = p
    if p > result.max:
      result.max = p

func projectionOverlaps(proj1, proj2: Projection): bool =
  if proj1.max < proj2.min: return false
  if proj2.max < proj1.min: return false
  result = true

func toPolygon(r: Rectangle): Polygon =
  @[(r.x, r.y), (r.x, r.y + r.h), (r.x + r.w, r.y + r.h), (r.x + r.w, r.y)]

func polygonOverlapsRect(poly1: Polygon; rect: Rectangle): bool =
  let poly2 = rect.toPolygon
  for axes in [poly1.axes, poly2.axes]:
    for axis in axes:
      let proj1 = poly1.projectionOnAxis(axis)
      let proj2 = poly2.projectionOnAxis(axis)
      if not projectionOverlaps(proj1, proj2):
        return false
  result = true

let poly = @[(0.0, 0.0), (0.0, 2.0), (1.0, 4.0), (2.0, 2.0), (2.0, 0.0)]
let rect1 = (4.0, 0.0, 2.0, 2.0)
let rect2 = (1.0, 0.0, 8.0, 2.0)

echo "poly n= ", poly
echo "rect1 = ", rect1, " → ", rect1.toPolygon
echo "rect2 = ", rect2, " → ", rect2.toPolygon
echo()
echo "poly and rect1 overlap? ", polygonOverlapsRect(poly, rect1)
echo "poly and rect2 overlap? ", polygonOverlapsRect(poly, rect2)
