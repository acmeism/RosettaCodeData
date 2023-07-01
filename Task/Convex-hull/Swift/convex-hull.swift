public struct Point: Equatable, Hashable {
  public var x: Double
  public var y: Double

  public init(fromTuple t: (Double, Double)) {
    self.x = t.0
    self.y = t.1
  }
}

public func calculateConvexHull(fromPoints points: [Point]) -> [Point] {
  guard points.count >= 3 else {
    return points
  }

  var hull = [Point]()
  let (leftPointIdx, _) = points.enumerated().min(by: { $0.element.x < $1.element.x })!

  var p = leftPointIdx
  var q = 0

  repeat {
    hull.append(points[p])

    q = (p + 1) % points.count

    for i in 0..<points.count where calculateOrientation(points[p], points[i], points[q]) == .counterClockwise {
      q = i
    }

    p = q
  } while p != leftPointIdx

  return hull
}

private func calculateOrientation(_ p: Point, _ q: Point, _ r: Point) -> Orientation {
  let val = (q.y - p.y) * (r.x - q.x) - (q.x - p.x) * (r.y - q.y)

  if val == 0 {
    return .straight
  } else if val > 0 {
    return .clockwise
  } else {
    return .counterClockwise
  }
}

private enum Orientation {
  case straight, clockwise, counterClockwise
}

let points = [
  (16,3),
  (12,17),
  (0,6),
  (-4,-6),
  (16,6),
  (16,-7),
  (16,-3),
  (17,-4),
  (5,19),
  (19,-8),
  (3,16),
  (12,13),
  (3,-4),
  (17,5),
  (-3,15),
  (-3,-9),
  (0,11),
  (-9,-3),
  (-4,-2),
  (12,10)
].map(Point.init(fromTuple:))

print("Input: \(points)")
print("Output: \(calculateConvexHull(fromPoints: points))")
