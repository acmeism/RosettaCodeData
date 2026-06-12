import Foundation
import CoreGraphics

func lineCircleIntersection(start: NSPoint, end: NSPoint, center: NSPoint,
                            radius: CGFloat, segment: Bool) -> [NSPoint] {
    var result: [NSPoint] = []
    let angle = atan2(end.y - start.y, end.x - start.x)
    var at = AffineTransform(rotationByRadians: angle)
    at.invert()
    at.translate(x: -center.x, y: -center.y)
    let p1 = at.transform(start)
    let p2 = at.transform(end)
    let minX = min(p1.x, p2.x), maxX = max(p1.x, p2.x)
    let y = p1.y
    at.invert()
    func addPoint(x: CGFloat, y: CGFloat) {
        if !segment || (x <= maxX && x >= minX) {
            result.append(at.transform(NSMakePoint(x, y)))
        }
    }
    if y == radius || y == -radius {
        addPoint(x: 0, y: y)
    } else if y < radius && y > -radius {
        let x = (radius * radius - y * y).squareRoot()
        addPoint(x: -x, y: y)
        addPoint(x: x, y: y)
    }
    return result
}

func toString(points: [NSPoint]) -> String {
    var result = "["
    result += points.map{String(format: "(%.4f, %.4f)", $0.x, $0.y)}.joined(separator: ", ")
    result += "]"
    return result
}

var center = NSMakePoint(3, -5)
var radius: CGFloat = 3

print("The intersection points (if any) between:")
print("\n  A circle, center (3, -5) with radius 3, and:")
print("\n    a line containing the points (-10, 11) and (10, -9) is/are:")
var points = lineCircleIntersection(start: NSMakePoint(-10, 11), end: NSMakePoint(10, -9),
                                    center: center, radius: radius,
                                    segment: false)
print("     \(toString(points: points))")
print("\n    a segment starting at (-10, 11) and ending at (-11, 12) is/are")
points = lineCircleIntersection(start: NSMakePoint(-10, 11), end: NSMakePoint(-11, 12),
                                center: center, radius: radius,
                                segment: true)
print("     \(toString(points: points))")
print("\n    a horizontal line containing the points (3, -2) and (7, -2) is/are:")
points = lineCircleIntersection(start: NSMakePoint(3, -2), end: NSMakePoint(7, -2),
                                center: center, radius: radius,
                                segment: false)
print("     \(toString(points: points))")

center.x = 0
center.y = 0
radius = 4

print("\n  A circle, center (0, 0) with radius 4, and:")
print("\n    a vertical line containing the points (0, -3) and (0, 6) is/are:")
points = lineCircleIntersection(start: NSMakePoint(0, -3), end: NSMakePoint(0, 6),
                                center: center, radius: radius,
                                segment: false)
print("     \(toString(points: points))")
print("\n    a vertical segment starting at (0, -3) and ending at (0, 6) is/are:")
points = lineCircleIntersection(start: NSMakePoint(0, -3), end: NSMakePoint(0, 6),
                                center: center, radius: radius,
                                segment: true)
print("     \(toString(points: points))")

center.x = 4
center.y = 2
radius = 5

print("\n  A circle, center (4, 2) with radius 5, and:")
print("\n    a line containing the points (6, 3) and (10, 7) is/are:")
points = lineCircleIntersection(start: NSMakePoint(6, 3), end: NSMakePoint(10, 7),
                                center: center, radius: radius,
                                segment: false)
print("     \(toString(points: points))")
print("\n    a segment starting at (7, 4) and ending at (11, 8) is/are:")
points = lineCircleIntersection(start: NSMakePoint(7, 4), end: NSMakePoint(11, 8),
                                center: center, radius: radius,
                                segment: true)
print("     \(toString(points: points))")
