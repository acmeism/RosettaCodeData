struct Point {
  var x: Double
  var y: Double
}

struct Line {
  var p1: Point
  var p2: Point

  var slope: Double {
    guard p1.x - p2.x != 0.0 else { return .nan }

    return (p1.y-p2.y) / (p1.x-p2.x)
  }

  func intersection(of other: Line) -> Point? {
    let ourSlope = slope
    let theirSlope = other.slope

    guard ourSlope != theirSlope else { return nil }

    if ourSlope.isNaN && !theirSlope.isNaN {
      return Point(x: p1.x, y: (p1.x - other.p1.x) * theirSlope + other.p1.y)
    } else if theirSlope.isNaN && !ourSlope.isNaN {
      return Point(x: other.p1.x, y: (other.p1.x - p1.x) * ourSlope + p1.y)
    } else {
      let x = (ourSlope*p1.x - theirSlope*other.p1.x + other.p1.y - p1.y) / (ourSlope - theirSlope)
      return Point(x: x, y: theirSlope*(x - other.p1.x) + other.p1.y)
    }
  }
}

let l1 = Line(p1: Point(x: 4.0, y: 0.0), p2: Point(x: 6.0, y: 10.0))
let l2 = Line(p1: Point(x: 0.0, y: 3.0), p2: Point(x: 10.0, y: 7.0))

print("Intersection at : \(l1.intersection(of: l2)!)")
