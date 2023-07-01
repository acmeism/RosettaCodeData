import sequtils, strformat

type
  Vec2 = tuple[x, y: float]
  Edge = tuple[p, q: Vec2]
  Polygon = seq[Vec2]


func `-`(a, b: Vec2): Vec2 = (a.x - b.x, a.y - b.y)

func cross(a, b: Vec2): float = a.x * b.y - a.y * b.x

func isInside(p: Vec2; edge: Edge): bool =
  (edge.q.x - edge.p.x) * (p.y - edge.p.y) > (edge.q.y - edge.p.y) * (p.x - edge.p.x)


func intersection(sEdge, cEdge: Edge): Vec2 =
  let
    dc = cEdge.p - cEdge.q
    dp = sEdge.p - sEdge.q
    n1 = cEdge.p.cross(cEdge.q)
    n2 = sEdge.p.cross(sEdge.q)
    n3 = 1 / dc.cross(dp)
  result = ((n1 * dp.x - n2 * dc.x) * n3, (n1 * dp.y - n2 * dc.y) * n3)


func edges(poly: Polygon): seq[Edge] =
  (poly[^1] & poly).zip(poly)


func clip(subjectPolygon, clipPolygon: Polygon): Polygon =
  assert subjectPolygon.len > 1
  assert clipPolygon.len > 1

  result = subjectPolygon
  for clipEdge in clipPolygon.edges:
    let inputList = move(result)
    result.reset()
    for inEdge in inputList.edges:
      if inEdge.q.isInside(clipEdge):
        if not inEdge.p.isInside(clipEdge):
          result.add intersection(inEdge, clipEdge)
        result.add inEdge.q
      elif inEdge.p.isInside(clipEdge):
        result.add intersection(inEdge, clipEdge)


proc saveEpsImage(filename: string; subject, clip, clipped: Polygon) =
  let eps = open(filename, fmWrite)
  eps.write "%%!PS-Adobe-3.0\n%%%%BoundingBox: 40 40 360 360\n/l {lineto} def\n/m {moveto} def\n",
            "/s {setrgbcolor} def\n/c {closepath} def\n/gs {fill grestore stroke} def\n"

  eps.write &"0 setlinewidth {clip[0].x} {clip[0].y} m "
  for i in 1..clip.high:
    eps.write &"{clip[i].x} {clip[i].y} l "
  eps.writeLine "c 0.5 0 0 s gsave 1 0.7 0.7 s gs"

  eps.write &"{subject[0].x} {subject[0].y} m "
  for i in 1..subject.high:
    eps.write &"{subject[i].x} {subject[i].y} l "
  eps.writeLine "c 0 0.2 0.5 s gsave 0.4 0.7 1 s gs"

  eps.write &"2 setlinewidth [10 8] 0 setdash {clipped[0].x} {clipped[0].y} m "
  for i in 1..clipped.high:
    eps.write &"{clipped[i].x} {clipped[i].y} l "
  eps.writeLine &"c 0.5 0 0.5 s gsave 0.7 0.3 0.8 s gs"

  eps.writeLine "%%%%EOF"
  eps.close()
  echo &"File “{filename}” written."


when isMainModule:

  let
    subjectPolygon = @[(50.0, 150.0), (200.0, 50.0), (350.0, 150.0),
                      (350.0, 300.0), (250.0, 300.0), (200.0, 250.0),
                      (150.0, 350.0), (100.0, 250.0), (100.0, 200.0)]
    clippingPolygon = @[(100.0, 100.0), (300.0, 100.0), (300.0, 300.0), (100.0, 300.0)]

    clipped = subjectPolygon.clip(clippingPolygon)

  for point in clipped:
    echo &"({point.x:.3f}, {point.y:.3f})"
  saveEpsImage("sutherland_hodgman_clipping_out.eps", subjectPolygon, clippingPolygon, clipped)
