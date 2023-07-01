import Foundation

struct Point {
  var x: Double
  var y: Double
}

extension Point: CustomStringConvertible {
  var description: String {
    return "Point(x: \(x), y: \(y))"
  }
}

struct Polygon {
  var points: [Point]

  var area: Double {
    let xx = points.map({ $0.x })
    let yy = points.map({ $0.y })
    let overlace = zip(xx, yy.dropFirst() + yy.prefix(1)).map({ $0.0 * $0.1 }).reduce(0, +)
    let underlace = zip(yy, xx.dropFirst() + xx.prefix(1)).map({ $0.0 * $0.1 }).reduce(0, +)

    return abs(overlace - underlace) / 2
  }

  init(points: [Point]) {
    self.points = points
  }

  init(points: [(Double, Double)]) {
    self.init(points: points.map({ Point(x: $0.0, y: $0.1) }))
  }
}

let poly = Polygon(points: [
  (3,4),
  (5,11),
  (12,8),
  (9,5),
  (5,6)
])

print("\(poly) area = \(poly.area)")
