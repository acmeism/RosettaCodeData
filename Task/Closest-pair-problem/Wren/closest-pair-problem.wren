import "./math" for Math
import "./sort" for Sort

var distance = Fn.new { |p1, p2| Math.hypot(p1[0] - p2[0], p1[1] - p2[1]) }

var bruteForceClosestPair = Fn.new { |p|
    var n = p.count
    if (n < 2) Fiber.abort("There must be at least two points.")
    var minPoints = [p[0], p[1]]
    var minDistance = distance.call(p[0], p[1])
    for (i in 0...n-1) {
        for (j in i+1...n) {
            var dist = distance.call(p[i], p[j])
            if (dist < minDistance) {
                minDistance = dist
                minPoints = [p[i], p[j]]
            }
        }
    }
    return [minDistance, minPoints]
}

var optimizedClosestPair // recursive so pre-declare
optimizedClosestPair = Fn.new { |xP, yP|
    var n = xP.count
    if (n <= 3) return bruteForceClosestPair.call(xP)
    var hn = (n/2).floor
    var xL = xP.take(hn).toList
    var xR = xP.skip(hn).toList
    var xm = xP[hn-1][0]
    var yL = yP.where { |p| p[0] <= xm }.toList
    var yR = yP.where { |p| p[0] >  xm }.toList
    var ll = optimizedClosestPair.call(xL, yL)
    var dL = ll[0]
    var pairL = ll[1]
    var rr = optimizedClosestPair.call(xR, yR)
    var dR = rr[0]
    var pairR = rr[1]
    var dmin = dR
    var pairMin = pairR
    if (dL < dR) {
        dmin = dL
        pairMin = pairL
    }
    var yS = yP.where { |p| (xm - p[0]).abs < dmin }.toList
    var nS = yS.count
    var closest = dmin
    var closestPair = pairMin
    for (i in 0...nS-1) {
        var k = i + 1
        while (k < nS && (yS[k][1] - yS[i][1] < dmin)) {
            var dist = distance.call(yS[k], yS[i])
            if (dist < closest) {
                closest = dist
                closestPair = [yS[k], yS[i]]
            }
            k = k + 1
        }
    }
    return [closest, closestPair]
}

var points = [
    [ [5, 9], [9, 3], [2, 0], [8, 4], [7, 4], [9, 10], [1, 9], [8, 2], [0, 10], [9, 6] ],

    [
        [0.654682, 0.925557], [0.409382, 0.619391], [0.891663, 0.888594],
        [0.716629, 0.996200], [0.477721, 0.946355], [0.925092, 0.818220],
        [0.624291, 0.142924], [0.211332, 0.221507], [0.293786, 0.691701],
        [0.839186, 0.728260]
    ]
]

for (p in points) {
    var dp = bruteForceClosestPair.call(p)
    var dist = dp[0]
    var pair = dp[1]
    System.print("Closest pair (brute force) is %(pair[0]) and %(pair[1]), distance %(dist)")
    var xP = Sort.merge(p) { |x, y| (x[0] - y[0]).sign }
    var yP = Sort.merge(p) { |x, y| (x[1] - y[1]).sign }
    dp = optimizedClosestPair.call(xP, yP)
    dist = dp[0]
    pair = dp[1]
    System.print("Closest pair (optimized)   is %(pair[0]) and %(pair[1]), distance %(dist)\n")
}
