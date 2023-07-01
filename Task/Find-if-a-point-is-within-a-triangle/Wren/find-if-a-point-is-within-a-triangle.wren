var EPS = 0.001
var EPS_SQUARE = EPS * EPS

var side = Fn.new { |x1, y1, x2, y2, x, y|
    return (y2 - y1)*(x - x1) + (-x2 + x1)*(y - y1)
}

var naivePointInTriangle = Fn.new { |x1, y1, x2, y2, x3, y3, x, y|
    var checkSide1 = side.call(x1, y1, x2, y2, x, y) >= 0
    var checkSide2 = side.call(x2, y2, x3, y3, x, y) >= 0
    var checkSide3 = side.call(x3, y3, x1, y1, x, y) >= 0
    return checkSide1 && checkSide2 && checkSide3
}

var pointInTriangleBoundingBox = Fn.new { |x1, y1, x2, y2, x3, y3, x, y|
    var xMin = x1.min(x2.min(x3)) - EPS
    var xMax = x1.max(x2.max(x3)) + EPS
    var yMin = y1.min(y2.min(y3)) - EPS
    var yMax = y1.max(y2.max(y3)) + EPS
    return !(x < xMin || xMax < x || y < yMin || yMax < y)
}

var distanceSquarePointToSegment = Fn.new { |x1, y1, x2, y2, x, y|
    var p1_p2_squareLength = (x2 - x1)*(x2 - x1) + (y2 - y1)*(y2 - y1)
    var dotProduct = ((x - x1)*(x2 - x1) + (y - y1)*(y2 - y1)) / p1_p2_squareLength
    if (dotProduct < 0) {
        return (x - x1)*(x - x1) + (y - y1)*(y - y1)
    } else if (dotProduct <= 1) {
        var p_p1_squareLength = (x1 - x)*(x1 - x) + (y1 - y)*(y1 - y)
        return p_p1_squareLength - dotProduct * dotProduct * p1_p2_squareLength
    } else {
        return (x - x2)*(x - x2) + (y - y2)*(y - y2)
    }
}

var accuratePointInTriangle = Fn.new { |x1, y1, x2, y2, x3, y3, x, y|
    if (!pointInTriangleBoundingBox.call(x1, y1, x2, y2, x3, y3, x, y)) return false
    if (naivePointInTriangle.call(x1, y1, x2, y2, x3, y3, x, y)) return true
    if (distanceSquarePointToSegment.call(x1, y1, x2, y2, x, y) <= EPS_SQUARE) return true
    if (distanceSquarePointToSegment.call(x2, y2, x3, y3, x, y) <= EPS_SQUARE) return true
    if (distanceSquarePointToSegment.call(x3, y3, x1, y1, x, y) <= EPS_SQUARE) return true
    return false
}

var pts = [ [0, 0], [0, 1], [3, 1]]
var tri = [ [3/2, 12/5], [51/10, -31/10], [-19/5, 1.2] ]
System.print("Triangle is %(tri)")
var x1 = tri[0][0]
var y1 = tri[0][1]
var x2 = tri[1][0]
var y2 = tri[1][1]
var x3 = tri[2][0]
var y3 = tri[2][1]

for (pt in pts) {
    var x = pt[0]
    var y = pt[1]
    var within = accuratePointInTriangle.call(x1, y1, x2, y2, x3, y3, x, y)
    System.print("Point %(pt) is within triangle ? %(within)")
}
System.print()
tri = [ [1/10, 1/9], [100/8, 100/3], [100/4, 100/9] ]
System.print("Triangle is %(tri)")
x1 = tri[0][0]
y1 = tri[0][1]
x2 = tri[1][0]
y2 = tri[1][1]
x3 = tri[2][0]
y3 = tri[2][1]
var x = x1 + (3/7)*(x2 - x1)
var y = y1 + (3/7)*(y2 - y1)
var pt = [x, y]
var within = accuratePointInTriangle.call(x1, y1, x2, y2, x3, y3, x, y)
System.print("Point %(pt) is within triangle ? %(within)")
System.print()
tri = [ [1/10, 1/9], [100/8, 100/3], [-100/8, 100/6] ]
System.print("Triangle is %(tri)")
x3 = tri[2][0]
y3 = tri[2][1]
within = accuratePointInTriangle.call(x1, y1, x2, y2, x3, y3, x, y)
System.print("Point %(pt) is within triangle ? %(within)")
