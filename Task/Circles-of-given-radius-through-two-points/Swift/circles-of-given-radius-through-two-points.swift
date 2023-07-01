import Foundation

struct Point: Equatable {
    var x: Double
    var y: Double
}

struct Circle {
  var center: Point
  var radius: Double

  static func circleBetween(
    _ p1: Point,
    _ p2: Point,
    withRadius radius: Double
  ) -> (Circle, Circle?)? {
    func applyPoint(_ p1: Point, _ p2: Point, op: (Double, Double) -> Double) -> Point {
      return Point(x: op(p1.x, p2.x), y: op(p1.y, p2.y))
    }

    func mul2(_ p: Point, mul: Double) -> Point {
      return Point(x: p.x * mul, y: p.y * mul)
    }

    func div2(_ p: Point, div: Double) -> Point {
      return Point(x: p.x / div, y: p.y / div)
    }

    func norm(_ p: Point) -> Point {
      return div2(p, div: (p.x * p.x + p.y * p.y).squareRoot())
    }

    guard radius != 0, p1 != p2 else {
      return nil
    }

    let diameter = 2 * radius
    let pq = applyPoint(p1, p2, op: -)
    let magPQ = (pq.x * pq.x + pq.y * pq.y).squareRoot()

    guard diameter >= magPQ else {
      return nil
    }

    let midpoint = div2(applyPoint(p1, p2, op: +), div: 2)
    let halfPQ = magPQ / 2
    let magMidC = abs(radius * radius - halfPQ * halfPQ).squareRoot()
    let midC = mul2(norm(Point(x: -pq.y, y: pq.x)), mul: magMidC)
    let center1 = applyPoint(midpoint, midC, op: +)
    let center2 = applyPoint(midpoint, midC, op: -)

    if center1 == center2 {
      return (Circle(center: center1, radius: radius), nil)
    } else {
      return (Circle(center: center1, radius: radius), Circle(center: center2, radius: radius))
    }
  }
}

let testCases = [
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.8765, y: 0.2345), 2.0),
  (Point(x: 0.0000, y: 2.0000), Point(x: 0.0000, y: 0.0000), 1.0),
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.1234, y: 0.9876), 2.0),
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.8765, y: 0.2345), 0.5),
  (Point(x: 0.1234, y: 0.9876), Point(x: 0.1234, y: 0.9876), 0.0)
]

for testCase in testCases {
  switch Circle.circleBetween(testCase.0, testCase.1, withRadius: testCase.2) {
  case nil:
    print("No ans")
  case (let circle1, nil)?:
    print("One ans: \(circle1)")
  case (let circle1, let circle2?)?:
    print("Two ans: \(circle1) \(circle2)")
  }
}
