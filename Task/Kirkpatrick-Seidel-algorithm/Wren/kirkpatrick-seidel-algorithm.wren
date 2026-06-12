import "random" for Random
import "./hash" for HashSet

var Rand = Random.new()

class Point {
    construct new(x, y) {
        _x = x
        _y = y
    }

    x { _x }
    y { _y }

    <(other)  { _x == other.x ? y < other.y : _x < other.x }

    ==(other) { _x == other.x && _y == other.y }

    !=(other) { !(this == other) }

    toString { "(%(_x), %(_y))" }
}

var flipped = Fn.new { |points|
    var result = []
    for (point in points) result.add(Point.new(-point.x, -point.y))
    return result
}

var QuickSelect = Fn.new { |ls, index, lo, hi|
    if (hi == -1) hi = ls.count - 1
    if (lo == hi) return ls[lo]
    var pivot = lo + Rand.int(hi - lo + 1)
    ls.swap(lo, pivot)
    var cur = lo
    var run = lo + 1
    while (run <= hi) {
        if (ls[run] < ls[lo]) {
            cur = cur + 1
            ls.swap(cur, run)
        }
        run = run + 1
    }
    ls.swap(cur, lo)
    if (index < cur) {
        return QuickSelect.call(ls, index, lo, cur - 1)
    } else if (index > cur) {
        return QuickSelect.call(ls, index, cur + 1, hi)
    } else {
        return ls[cur]
    }
}

var Bridge = Fn.new { |pointsSet, verticalLine|
    var points = pointsSet.toList
    if (points.count == 2) return [points[0], points[1]]
    var candidates = HashSet.new()
    var pairs = []
    var modifyS = points.toList

    while (modifyS.count >= 2) {
        var p1 = modifyS.removeAt(0)
        var p2 = modifyS.removeAt(0)

        if (p1 < p2) {
            pairs.add([p1, p2])
        } else {
            pairs.add([p2, p1])
        }
    }

    if (modifyS.count == 1) candidates.add(modifyS[0])
    var slopes = []

    var i = 0
    while (i < pairs.count) {
        var p = pairs[i]
        var pi = p[0]
        var pj = p[1]
        if (pi.x == pj.x) {
            candidates.add(pi.y > pj.y ? pi : pj)
            pairs.removeAt(i)
            i = i - 1
        } else {
            slopes.add((pi.y - pj.y) / (pi.x - pj.x))
        }
        i = i + 1
    }

    if (slopes.count == 0) {
        // Handle case when no valid pairs with slopes are found.
        if (candidates.count >= 2) {
            var candidatesArray = candidates.toList
            return [candidatesArray[0], candidatesArray[1]]
        }
        // If we don't have enough candidates, return the first pair.
        return [points[0], points[1]]
    }

    var medianIndex = (slopes.count / 2).floor - (slopes.count % 2 == 0 ? 1 : 0)
    var medianSlope = QuickSelect.call(slopes.toList, medianIndex, 0, -1)

    var small = []
    var equal = []
    var large = []

    for (i in 0...slopes.count) {
        if (slopes[i] < medianSlope) {
            small.add(pairs[i])
        } else if (slopes[i] == medianSlope) {
            equal.add(pairs[i])
        } else {
            large.add(pairs[i])
        }
    }

    var maxSlope = -Num.infinity
    for (point in points) {
        maxSlope = maxSlope.max(point.y - medianSlope * point.x)
    }

    var maxSet = []
    for (point in points) {
        if (point.y - medianSlope * point.x == maxSlope) {
            maxSet.add(point)
        }
    }

    var left  = maxSet[0]
    var right = maxSet[0]
	for (p in maxSet.skip(1)) {
		if (p < left) left = p
		if (!(p < right)) right = p
	}

    if (left.x <= verticalLine && right.x > verticalLine) {
        return [left, right]
    }

    if (right.x <= verticalLine) {
        for (pair in large) candidates.add(pair[1])
        for (pair in equal) candidates.add(pair[1])
        for (pair in small) {
            candidates.add(pair[0])
            candidates.add(pair[1])
        }
    }

    if (left.x > verticalLine) {
        for (pair in small) candidates.add(pair[0])
        for (pair in equal) candidates.add(pair[0])
        for (pair in large) {
            candidates.add(pair[0])
            candidates.add(pair[1])
        }
    }

    return Bridge.call(candidates, verticalLine)
}

var Connect = Fn.new { |lower, upper, pointsSet|
    var points = pointsSet.toList
    if (lower == upper) return [lower]

    var pointsVec = points.toList
    var midIndex  = (pointsVec.count / 2).floor - 1

    var maxLeft   = QuickSelect.call(pointsVec.toList, midIndex, 0, -1)
    var minRight  = QuickSelect.call(pointsVec.toList, midIndex + 1, 0, -1)

    var lr = Bridge.call(HashSet.new(points), (maxLeft.x + minRight.x) / 2)
    var left = lr[0]
    var right = lr[1]
    var pointsLeft  = HashSet.new([left])
    var pointsRight = HashSet.new([right])

    for (point in points) {
        if (point.x < left.x) {
            pointsLeft.add(point)
        } else if (point.x > right.x) {
            pointsRight.add(point)
        }
    }

    var leftResult  = Connect.call(lower, left, pointsLeft)
    var rightResult = Connect.call(right, upper, pointsRight)
    return leftResult + rightResult
}

var upperHull = Fn.new { |pointsSet|
    var points = pointsSet.toList

    // Find the leftmost point.
    var lower = points[0]
    for (p in points.skip(1)) {
        if (p.x < lower.x || (p.x == lower.x && p.y < lower.y)) lower = p
    }

    // Find the lowest point with the same x-coordinate as the minimum.
    for (point in points) {
        if (point.x == lower.x && point.y > lower.y) lower = point
    }

    // Find the rightmost point.
    var upper = points[0]
    for (p in points.skip(1)) {
        if (p.x > upper.x || (p.x == upper.x && p.y > upper.y)) upper = p
    }

    var filteredPoints = HashSet.new([lower, upper])
    for (p in points) {
        if (lower.x < p.x && p.x < upper.x) filteredPoints.add(p)
    }

    return Connect.call(lower, upper, filteredPoints)
}

var convexHull = Fn.new { |pointsSet|
    var points = pointsSet.toList
    var upper = upperHull.call(HashSet.new(points))

    var flippedPoints = HashSet.new()
    for (p in points) {
        flippedPoints.add(Point.new(-p.x, -p.y))
    }

    var flippedUpper = upperHull.call(flippedPoints)
    var lower = flipped.call(flippedUpper)
    if (upper[-1] == lower[0]) upper.removeAt(-1)
    if (upper[0] == lower[-1]) lower.removeAt(-1)
    return upper + lower
}

/* Test case for a simplex */

// Create points for a 2D projection of a 3D simplex.
var points = HashSet.new([
    Point.new(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
    Point.new(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
    Point.new(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
    Point.new(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
])

System.print("Input points:")
for (p in points) System.print(p)

var hull = convexHull.call(points)

System.print("\nConvex hull points:")
for (p in hull) System.print(p)
