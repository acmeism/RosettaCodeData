import fenv, sequtils, strformat

type
  Point = tuple[x, y: float]
  Edge = tuple[a, b: Point]
  Figure = tuple[name: string; edges: seq[Edge]]


func contains(poly: Figure; p: Point): bool =

  func raySegI(p: Point; edge: Edge): bool =
    const Epsilon = 0.00001
    if edge.a.y > edge.b.y:
      # Swap "a" and "b".
      return p.raySegI((edge.b, edge.a))
    if p.y == edge.a.y or p.y == edge.b.y:
      # p.y += Epsilon.
      return (p.x, p.y + Epsilon).raySegI(edge)
    if p.y > edge.b.y or p.y < edge.a.y or p.x > max(edge.a.x, edge.b.x):
      return false
    if p.x < min(edge.a.x, edge.b.x):
      return true
    let blue = if abs(edge.a.x - p.x) > minimumPositiveValue(float):
                 (p.y - edge.a.y) / (p.x - edge.a.x)
               else:
                 maximumPositiveValue(float)
    let red = if abs(edge.a.x - edge.b.x) > minimumPositiveValue(float):
                (edge.b.y - edge.a.y) / (edge.b.x - edge.a.x)
              else:
                maximumPositiveValue(float)
    result = blue >= red

  result = (poly.edges.filterIt(p.raySegI(it)).len and 1) != 0


when isMainModule:

  const
    Polys: array[4, Figure] =
      [("Square",
        @[(( 0.0,  0.0), (10.0,  0.0)),  ((10.0,  0.0), (10.0, 10.0)),
          ((10.0, 10.0), ( 0.0, 10.0)),  (( 0.0, 10.0), ( 0.0,  0.0))]),
       ("Square hole",
        @[(( 0.0,  0.0), (10.0,  0.0)),  ((10.0,  0.0), (10.0, 10.0)),
          ((10.0, 10.0), ( 0.0, 10.0)),  (( 0.0, 10.0), ( 0.0,  0.0)),
          (( 2.5,  2.5), ( 7.5,  2.5)),  (( 7.5,  2.5), ( 7.5,  7.5)),
          (( 7.5,  7.5), ( 2.5,  7.5)),  (( 2.5,  7.5), ( 2.5,  2.5))]),
       ("Strange",
        @[(( 0.0,  0.0), ( 2.5,  2.5)),  (( 2.5,  2.5), ( 0.0, 10.0)),
          (( 0.0, 10.0), ( 2.5,  7.5)),  (( 2.5,  7.5), ( 7.5,  7.5)),
          (( 7.5,  7.5), (10.0, 10.0)),  ((10.0, 10.0), (10.0,  0.0)),
          ((10.0,  0.0),   ( 2.5,  2.5))]),
       ("Hexagon",
        @[(( 3.0,  0.0), ( 7.0,  0.0)),  (( 7.0,  0.0), (10.0,  5.0)),
          ((10.0,  5.0), ( 7.0, 10.0)),  (( 7.0, 10.0), ( 3.0, 10.0)),
          (( 3.0, 10.0), ( 0.0,  5.0)),  (( 0.0,  5.0), ( 3.0,  0.0))])
      ]

    TestPoints: array[7, Point] =
      [(5.0, 5.0), (5.0, 8.0), (-10.0, 5.0), (0.0, 5.0), (10.0, 5.0), (8.0, 5.0), (10.0, 10.0)]

  for poly in Polys:
    echo &"Is point inside figure {poly.name}?"
    for p in TestPoints:
      echo &"  ({p.x:3},{p.y:3}): {poly.contains(p)}"
