// version 1.1.2

typealias Point = Pair<Double, Double>

fun distance(p1: Point, p2: Point) = Math.hypot(p1.first- p2.first, p1.second - p2.second)

fun bruteForceClosestPair(p: List<Point>): Pair<Double, Pair<Point, Point>> {
    val n = p.size
    if (n < 2) throw IllegalArgumentException("Must be at least two points")
    var minPoints = p[0] to p[1]
    var minDistance = distance(p[0], p[1])
    for (i in 0 until n - 1)
        for (j in i + 1 until n) {
            val dist = distance(p[i], p[j])
            if (dist < minDistance) {
                minDistance = dist
                minPoints = p[i] to p[j]
            }
        }
    return minDistance to Pair(minPoints.first, minPoints.second)
}

fun optimizedClosestPair(xP: List<Point>, yP: List<Point>): Pair<Double, Pair<Point, Point>> {
    val n = xP.size
    if (n <= 3) return bruteForceClosestPair(xP)
    val xL = xP.take(n / 2)
    val xR = xP.drop(n / 2)
    val xm = xP[n / 2 - 1].first
    val yL = yP.filter { it.first <= xm }
    val yR = yP.filter { it.first >  xm }
    val (dL, pairL) = optimizedClosestPair(xL, yL)
    val (dR, pairR) = optimizedClosestPair(xR, yR)
    var dmin = dR
    var pairMin = pairR
    if (dL < dR) {
        dmin = dL
        pairMin = pairL
    }
    val yS = yP.filter { Math.abs(xm - it.first) < dmin }
    val nS = yS.size
    var closest = dmin
    var closestPair = pairMin
    for (i in 0 until nS - 1) {
        var k = i + 1
        while (k < nS && (yS[k].second - yS[i].second < dmin)) {
            val dist = distance(yS[k], yS[i])
            if (dist < closest) {
                closest = dist
                closestPair = Pair(yS[k], yS[i])
            }
            k++
        }
    }
    return closest to closestPair
}


fun main(args: Array<String>) {
    val points = listOf(
        listOf(
            5.0 to  9.0, 9.0 to 3.0,  2.0 to 0.0, 8.0 to  4.0, 7.0 to 4.0,
            9.0 to 10.0, 1.0 to 9.0,  8.0 to 2.0, 0.0 to 10.0, 9.0 to 6.0
        ),
        listOf(
            0.654682 to 0.925557, 0.409382 to 0.619391, 0.891663 to 0.888594,
            0.716629 to 0.996200, 0.477721 to 0.946355, 0.925092 to 0.818220,
            0.624291 to 0.142924, 0.211332 to 0.221507, 0.293786 to 0.691701,
            0.839186 to 0.728260
        )
    )
    for (p in points) {
        val (dist, pair) = bruteForceClosestPair(p)
        println("Closest pair (brute force) is ${pair.first} and ${pair.second}, distance $dist")
        val xP = p.sortedBy { it.first }
        val yP = p.sortedBy { it.second }
        val (dist2, pair2) = optimizedClosestPair(xP, yP)
        println("Closest pair (optimized)   is ${pair2.first} and ${pair2.second}, distance $dist2\n")
    }
}
