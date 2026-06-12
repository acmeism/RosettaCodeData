import "./dynamic" for Struct, Enum
import "./seq" for Lst

class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    ==(other) { _x == other.x  && _y == other.y }

    !=(other) { !(this == other) }

    toString { "(%(_x), %(_y))" }
}

var Line = Struct.create("Line", ["start", "end"])

class Polygon {
    construct new(points) {
        _points = points
    }

    points { _points }

    copy() { Polygon.new(_points.toList) }
}

var InterVertexType = Enum.create(
    "InterVertexType",
    ["insideVertex", "outsideVertex", "inIntersection", "outIntersection"]
)

class InterVertex {
    static getFirstInIntersection(list) {
        var found = 0
        var result = null
        for (i in 0...list.count) {
            if (list[i].type == InterVertexType.inIntersection) {
                found = i
                result = list[i].point
                break
            }
        }
        if (found > 0) for (j in found-1..0) list.removeAt(j)
        return result
    }

    construct new(type, point) {
        _type = type
        _point = point
    }

    type  { _type }
    point { _point }
}

var PolyListOptionType = Enum.create(
    "PolyListOptionType",
    ["list", "insidePoly", "none"]
)

var PolyListOption = Struct.create(
    "PolyListOption",
    ["type", "interVertexList", "points"]
)

var isInPolygon = Fn.new { |point, poly|
    var x = point.x
    var y = point.y
    var inside = false
    var j = poly.points.count - 1

    for (i in 0...poly.points.count) {
        var xi = poly.points[i].x
        var yi = poly.points[i].y
        var xj = poly.points[j].x
        var yj = poly.points[j].y

        var intersect = (yi > y) != (yj > y) &&  x < (xj - xi) * (y - yi) / (yj - yi) + xi
        if (intersect) inside = !inside
        j = i
    }

    return inside
}

var distanceCmp = Fn.new { |self, first, second|
    var dstFirst = (self.x - first.x).abs + (self.y - first.y).abs
    var dstSecond = (self.x - second.x).abs + (self.y - second.y).abs

    if (dstFirst < dstSecond) {
        return -1
    } else if (dstFirst > dstSecond) {
        return 1
    } else {
        return 0
    }
}

var isInLine = Fn.new { |point, line|
    var dxc = point.x - line.start.x
    var dyc = point.y - line.start.y

    var dxl = line.end.x - line.start.x
    var dyl = line.end.y - line.start.y

    var cross = dxc * dyl - dyc * dxl
    if (cross != 0) return false

    if (dxl.abs >= dyl.abs) {
        if (dxl > 0) {
            return line.start.x <= point.x && point.x <= line.end.x
        } else {
            return line.end.x <= point.x && point.x <= line.start.x
        }
    } else {
        if (dyl > 0) {
            return line.start.y <= point.y && point.y <= line.end.y
        } else {
            return line.end.y <= point.y && point.y <= line.start.y
        }
    }
}

var getIntersection = Fn.new { |self, line|
    var line1Start = self.start
    var line1End = self.end
    var line2Start = line.start
    var line2End = line.end

    var den = (line2End.y - line2Start.y) * (line1End.x - line1Start.x) -
              (line2End.x - line2Start.x) * (line1End.y - line1Start.y)

    if (den == 0) return null

    var a = line1Start.y - line2Start.y
    var b = line1Start.x - line2Start.x

    var num1 = (line2End.x - line2Start.x) * a - (line2End.y - line2Start.y) * b
    var num2 = (line1End.x - line1Start.x) * a - (line1End.y - line1Start.y) * b

    var af = num1 / den
    var bf = num2 / den

    if (af < 0 || af > 1 || bf < 0 || bf > 1) return null

    return Point.new(
        line1Start.x + (af * (line1End.x - line1Start.x)).round,
        line1Start.y + (af * (line1End.y - line1Start.y)).round
    )
}

var isClockwise = Fn.new { |poly|
    var sum = 0
    for (i in 0...poly.points.count) {
        var j = (i != poly.points.count - 1) ? i + 1 : 0
        sum = sum + (poly.points[j].x - poly.points[i].x) * (poly.points[j].y + poly.points[i].y)
    }
    return sum < 0
}

var getReversed = Fn.new { |poly| Polygon.new(poly.points.toList[-1..0]) }

var getFirstOutsideVertexIndex = Fn.new { |subject, poly|
    for (i in 0...subject.points.count) {
        if (!isInPolygon.call(subject.points[i], poly)) return i
    }
    return null
}

var getFirstInsideVertexIndex = Fn.new { |subject, poly|
    for (i in 0...subject.points.count) {
        if (isInPolygon.call(subject.points[i], poly)) return i
    }
    return null
}

var getIntersectionsWithLine = Fn.new { |poly, line, cursorInside|
    var intersections = []

    for (i in 0...poly.points.count) {
        var start = poly.points[i]
        var nextI = (i == poly.points.count - 1) ? 0 : i + 1
        var end = poly.points[nextI]

        var l = Line.new(start, end)
        var intersection = getIntersection.call(l, line)

        if (intersection && intersection != line.start && intersection != line.end &&
            intersection != start && intersection != end) {
            intersections.add(intersection)
        }
    }
    intersections.sort { |a, b| distanceCmp.call(line.start, a, b) < 0 }

    var result = []
    for (x in intersections) {
        if (cursorInside[0]) {
            cursorInside[0] = !cursorInside[0]
            result.add(InterVertex.new(InterVertexType.outIntersection, x))
        } else {
            cursorInside[0] = !cursorInside[0]
            result.add(InterVertex.new(InterVertexType.inIntersection, x))
        }
    }

    return result
}

var getInterVertexList = Fn.new { |subject, poly|
    var subjectCopy = subject.copy()
    if (!isClockwise.call(subjectCopy)) subjectCopy = getReversed.call(subjectCopy)
    var cursorInside = false
    var intersectionCount = 0

    var startIndexOpt = getFirstOutsideVertexIndex.call(subjectCopy, poly)
    if (startIndexOpt) {
        var startIndex = startIndexOpt
        if (getFirstInsideVertexIndex.call(subjectCopy, poly) == 0) {
            var allInside = true
            for (point in poly.points) {
                if (!isInPolygon.call(point, subjectCopy)) {
                    allInside = false
                    break
                }
            }

            if (allInside) {
                return PolyListOption.new(PolyListOptionType.insidePoly, [], poly.points)
            }
        }

        var result = []

        for (iOffset in 0...subjectCopy.points.count) {
            var i = (startIndex + iOffset) % subjectCopy.points.count
            var start = subjectCopy.points[i]
            // Check vertex.
            if (i != startIndex && isInPolygon.call(start, poly)) {
                result.add(InterVertex.new(InterVertexType.insideVertex, start))
            } else {
                result.add(InterVertex.new(InterVertexType.outsideVertex, start))
            }
            // Check intersection.
            var nextI = (i == subjectCopy.points.count - 1) ? 0 : i + 1
            var end = subjectCopy.points[nextI]
            var line = Line.new(start, end)
            var cil = [cursorInside] // cursorInside is passed by reference
            var intersections = getIntersectionsWithLine.call(poly, line, cil)
            cursorInside = cil[0]
            intersectionCount = intersectionCount + intersections.count
            result.addAll(intersections)
        }

        // Check if there are any intersections
        var hasIntersections = false
        for (vertex in result) {
            if (vertex.type == InterVertexType.inIntersection ||
                vertex.type == InterVertexType.outIntersection) {
                hasIntersections = true
                break
            }
        }

        if (!hasIntersections) {
            return PolyListOption.new(PolyListOptionType.none, [], [])
        } else {
            return PolyListOption.new(PolyListOptionType.list, result, [])
        }
    } else {
        return PolyListOption.new(PolyListOptionType.insidePoly, [], subject.points)
    }
}

var collectFromList = Fn.new { |list, startPoint|
    var initialVertexNotFound = true
    var lastPoint = null
    var startI = 0
    var endI = 0
    var dontSkip = list[0].point == startPoint

    var points = []
    var i = 0

    // Skip until inIntersection occurs, but include the inIntersection.
    while (i < list.count && initialVertexNotFound && !dontSkip) {
        var next = (i == list.count - 1) ? 0 : i + 1
        var nextPoint = list[next]

        if (nextPoint.type == InterVertexType.inIntersection ||
            nextPoint.type == InterVertexType.outIntersection) {
            if (nextPoint.point == startPoint) {
                startI = next
                initialVertexNotFound = false
                break
            }
        }
        i = i + 1
    }

    // Collect points.
    if (!initialVertexNotFound || dontSkip) {
        i = startI
        var continueCollecting = true

        while (continueCollecting && i < list.count) {
            var vertex = list[i]

            if (vertex.type == InterVertexType.outIntersection) {
                endI = i
                lastPoint = vertex.point
                continueCollecting = false
            } else {
                points.add(vertex.point)
            }
            i = i + 1
        }
    }

    var amount = endI - startI + 1
    if (endI >= startI && startI + amount <= list.count) {
        for (j in startI + amount - 1..startI) list.removeAt(j)
    }

    if (!points.isEmpty && lastPoint) {
        return [points, lastPoint]
    } else {
        return null
    }
}

var getClipPolygon = Fn.new { |subject, clip, initial|
    var result = []
    var subjectAsList = true
    var startPoint = initial
    var endPoint = subject[-1].point

    while (!(initial == endPoint)) {
        var values = collectFromList.call(subjectAsList ? subject : clip, startPoint)
        if (values) {
            var edges = values[0]
            var end = values[1]
            endPoint = end
            startPoint = end
            subjectAsList = !subjectAsList
            result.addAll(edges)
        } else {
            System.print("something went wrong")
            System.print("res size: %(result.count)")
            return null
        }
    }

    if (!result.isEmpty) {
        // Filter consecutive duplicate points.
        return Lst.prune(result)
    } else {
        return null
    }
}

var getClipPolygons = Fn.new { |subject, clip|
    var result = []

    while (true) {
        var startPointOpt = InterVertex.getFirstInIntersection(subject)
        if (!startPointOpt) break
        var poly = getClipPolygon.call(subject, clip, startPointOpt)
        if (poly) {
            result.add(poly)
        } else {
            break
        }
    }
    if (!result.isEmpty) {
        return result
    } else {
        return null
    }
}

var clip = Fn.new { |self, other|
    var option = getInterVertexList.call(self, other)
    var otherOption = getInterVertexList.call(other, self)

    if (option.type == PolyListOptionType.list) {
        var subjectList = option.interVertexList
        if (otherOption.type == PolyListOptionType.list) {
            var clipList = otherOption.interVertexList
            return getClipPolygons.call(subjectList, clipList)
        } else if (otherOption.type == PolyListOptionType.insidePoly) {
            return [otherOption.points]
        } else { // None
            return null
        }
    } else if (option.type == PolyListOptionType.insidePoly) {
        return [option.points]
    } else { // None
        return null
    }
}

// Testing function.
var runTests = Fn.new {
    // Test isInLine.
    {
        var p = Point.new(5, 10)
        var line = Line.new(Point.new(5, 5), Point.new(5, 20))
        var result = isInLine.call(p, line)
        System.print("isInLine test 1: %(result ? "PASS" : "FAIL")")

        var pf = Point.new(3, 4)
        var linef = Line.new(Point.new(5, 5), Point.new(5, 20))
        var resultf = isInLine.call(pf, linef)
        System.print("isInLine test 2: %(!resultf ? "PASS" : "FAIL")")
    }

    // Test clip.
    {
        var poly = Polygon.new(
            [Point.new(180, 420), Point.new(180, 120), Point.new(520, 120),
             Point.new(520, 420), Point.new(420, 420), Point.new(320, 220)]
        )

        var interPolygon = Polygon.new(
            [Point.new(60, 220), Point.new(330, 120), Point.new(410, 290),
             Point.new(80, 480), Point.new(280, 280)]
        )

        var polygons = clip.call(poly, interPolygon)
        if (polygons && !polygons.isEmpty) {
            System.print("clip test: PASS - Found %(polygons.count) polygons")

            // Print first polygon points.
            if (!polygons[0].isEmpty) {
                System.print("First polygon points:")
                for (p in polygons[0]) {
                    System.print("  Point: %(p)")
                }
            }
        } else {
            System.print("clip test: FAIL - No polygons found")
        }
    }
}

runTests.call()
