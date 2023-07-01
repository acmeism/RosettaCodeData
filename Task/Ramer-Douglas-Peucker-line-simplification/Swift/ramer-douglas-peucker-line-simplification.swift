struct Point: CustomStringConvertible {
    let x: Double, y: Double

    var description: String {
        return "(\(x), \(y))"
    }
}

// Returns the distance from point p to the line between p1 and p2
func perpendicularDistance(p: Point, p1: Point, p2: Point) -> Double {
    let dx = p2.x - p1.x
    let dy = p2.y - p1.y
    let d = (p.x * dy - p.y * dx + p2.x * p1.y - p2.y * p1.x)
    return abs(d)/(dx * dx + dy * dy).squareRoot()
}

func ramerDouglasPeucker(points: [Point], epsilon: Double) -> [Point] {
    var result : [Point] = []
    func rdp(begin: Int, end: Int) {
        guard end > begin else {
            return
        }
        var maxDist = 0.0
        var index = 0
        for i in begin+1..<end {
            let dist = perpendicularDistance(p: points[i], p1: points[begin],
                                             p2: points[end])
            if dist > maxDist {
                maxDist = dist
                index = i
            }
        }
        if maxDist > epsilon {
            rdp(begin: begin, end: index)
            rdp(begin: index, end: end)
        } else {
            result.append(points[end])
        }
    }
    if points.count > 0 && epsilon >= 0.0 {
        result.append(points[0])
        rdp(begin: 0, end: points.count - 1)
    }
    return result
}

let points = [
    Point(x: 0.0, y: 0.0),
    Point(x: 1.0, y: 0.1),
    Point(x: 2.0, y: -0.1),
    Point(x: 3.0, y: 5.0),
    Point(x: 4.0, y: 6.0),
    Point(x: 5.0, y: 7.0),
    Point(x: 6.0, y: 8.1),
    Point(x: 7.0, y: 9.0),
    Point(x: 8.0, y: 9.0),
    Point(x: 9.0, y: 9.0)
]
print("\(ramerDouglasPeucker(points: points, epsilon: 1.0))")
