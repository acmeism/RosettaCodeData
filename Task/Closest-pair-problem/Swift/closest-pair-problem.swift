import Foundation

struct Point {
  var x: Double
  var y: Double

  func distance(to p: Point) -> Double {
    let x = pow(p.x - self.x, 2)
    let y = pow(p.y - self.y, 2)

    return (x + y).squareRoot()
  }
}

extension Collection where Element == Point {
  func closestPair() -> (Point, Point)? {
    let (xP, xY) = (sorted(by: { $0.x < $1.x }), sorted(by: { $0.y < $1.y }))

    return Self.closestPair(xP, xY)?.1
  }

  static func closestPair(_ xP: [Element], _ yP: [Element]) -> (Double, (Point, Point))? {
    guard xP.count > 3 else { return xP.closestPairBruteForce() }

    let half = xP.count / 2
    let xl = Array(xP[..<half])
    let xr = Array(xP[half...])
    let xm = xl.last!.x
    let (yl, yr) = yP.reduce(into: ([Element](), [Element]()), {cur, el in
      if el.x > xm {
        cur.1.append(el)
      } else {
        cur.0.append(el)
      }
    })

    guard let (distanceL, pairL) = closestPair(xl, yl) else { return nil }
    guard let (distanceR, pairR) = closestPair(xr, yr) else { return nil }

    let (dMin, pairMin) = distanceL > distanceR ? (distanceR, pairR) : (distanceL, pairL)

    let ys = yP.filter({ abs(xm - $0.x) < dMin })

    var (closest, pairClosest) = (dMin, pairMin)

    for i in 0..<ys.count {
      let p1 = ys[i]

      for k in i+1..<ys.count {
        let p2 = ys[k]

        guard abs(p2.y - p1.y) < dMin else { break }

        let distance = abs(p1.distance(to: p2))

        if distance < closest {
          (closest, pairClosest) = (distance, (p1, p2))
        }
      }
    }

    return (closest, pairClosest)
  }

  func closestPairBruteForce() -> (Double, (Point, Point))? {
    guard count >= 2 else { return nil }

    var closestPoints = (self.first!, self[index(after: startIndex)])
    var minDistance = abs(closestPoints.0.distance(to: closestPoints.1))

    guard count != 2 else { return (minDistance, closestPoints) }

    for i in 0..<count {
      for j in i+1..<count {
        let (iIndex, jIndex) = (index(startIndex, offsetBy: i), index(startIndex, offsetBy: j))
        let (p1, p2) = (self[iIndex], self[jIndex])

        let distance = abs(p1.distance(to: p2))

        if distance < minDistance {
          minDistance = distance
          closestPoints = (p1, p2)
        }
      }
    }

    return (minDistance, closestPoints)
  }
}

var points = [Point]()

for _ in 0..<10_000 {
  points.append(Point(
    x: .random(in: -10.0...10.0),
    y: .random(in: -10.0...10.0)
  ))
}

print(points.closestPair()!)
