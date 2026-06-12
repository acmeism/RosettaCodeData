type
  Vector2 = (float, float)
  Projection = tuple[min, max: float]
  Polygon = seq[Vector2]

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

func polygonsOverlap(poly1, poly2: Polygon): bool =
  for axes in [poly1.axes, poly2.axes]:
    for axis in axes:
      let proj1 = poly1.projectionOnAxis(axis)
      let proj2 = poly2.projectionOnAxis(axis)
      if not projectionOverlaps(proj1, proj2):
        return false
  result = true

let poly1 = @[(0.0, 0.0), (0.0, 2.0), (1.0, 4.0), (2.0, 2.0), (2.0, 0.0)]
let poly2 = @[(4.0, 0.0), (4.0, 2.0), (5.0, 4.0), (6.0, 2.0), (6.0, 0.0)]
let poly3 = @[(1.0, 0.0), (1.0, 2.0), (5.0, 4.0), (9.0, 2.0), (9.0, 0.0)]

echo "poly1 = ", poly1
echo "poly2 = ", poly2
echo "poly3 = ", poly3
echo()
echo "poly1 and poly2 overlap? ", polygonsOverlap(poly1, poly2)
echo "poly1 and poly3 overlap? ", polygonsOverlap(poly1, poly3)
echo "poly2 and poly3 overlap? ", polygonsOverlap(poly2, poly3)
