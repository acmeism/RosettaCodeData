struct Point {
  var x: Double
  var y: Double
}

struct Polygon {
  var points: [Point]

  init(points: [Point]) {
    self.points = points
  }

  init(points: [(Double, Double)]) {
    self.init(points: points.map({ Point(x: $0.0, y: $0.1) }))
  }
}

func isInside(_ p1: Point, _ p2: Point, _ p3: Point) -> Bool {
  (p3.x - p2.x) * (p1.y - p2.y) > (p3.y - p2.y) * (p1.x - p2.x)
}

func computeIntersection(_ p1: Point, _ p2: Point, _ s: Point, _ e: Point) -> Point {
  let dc = Point(x: p1.x - p2.x, y: p1.y - p2.y)
  let dp = Point(x: s.x - e.x, y: s.y - e.y)
  let n1 = p1.x * p2.y - p1.y * p2.x
  let n2 = s.x * e.y - s.y * e.x
  let n3 = 1.0 / (dc.x * dp.y - dc.y * dp.x)

  return Point(x: (n1 * dp.x - n2 * dc.x) * n3, y: (n1 * dp.y - n2 * dc.y) * n3)
}

func sutherlandHodgmanClip(subjPoly: Polygon, clipPoly: Polygon) -> Polygon {
  var ring = subjPoly.points
  var p1 = clipPoly.points.last!

  for p2 in clipPoly.points {
    let input = ring
    var s = input.last!

    ring = []

    for e in input {
      if isInside(e, p1, p2) {
        if !isInside(s, p1, p2) {
          ring.append(computeIntersection(p1, p2, s, e))
        }

        ring.append(e)
      } else if isInside(s, p1, p2) {
        ring.append(computeIntersection(p1, p2, s, e))
      }

      s = e
    }

    p1 = p2
  }

  return Polygon(points: ring)
}

let subj = Polygon(points: [
  (50.0, 150.0),
  (200.0, 50.0),
  (350.0, 150.0),
  (350.0, 300.0),
  (250.0, 300.0),
  (200.0, 250.0),
  (150.0, 350.0),
  (100.0, 250.0),
  (100.0, 200.0)
])

let clip = Polygon(points: [
  (100.0, 100.0),
  (300.0, 100.0),
  (300.0, 300.0),
  (100.0, 300.0)
])

print(sutherlandHodgmanClip(subjPoly: subj, clipPoly: clip))
