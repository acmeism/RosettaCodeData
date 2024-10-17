// version 1.2.21

import java.util.Random
import kotlin.math.*

data class Point(var x: Double, var y: Double, var group: Int)

typealias LPoint = List<Point>
typealias MLPoint = MutableList<Point>

val origin get() = Point(0.0, 0.0, 0)
val r = Random()
val hugeVal = Double.POSITIVE_INFINITY

const val RAND_MAX = Int.MAX_VALUE
const val PTS = 100_000
const val K = 11
const val W = 400
const val H = 400

fun rand() = r.nextInt(RAND_MAX)

fun randf(m: Double) = m * rand() / (RAND_MAX - 1)

fun genXY(count: Int, radius: Double): LPoint {
    val pts = List(count) { origin }

    /* note: this is not a uniform 2-d distribution */
    for (i in 0 until count) {
        val ang = randf(2.0 * PI)
        val r = randf(radius)
        pts[i].x = r * cos(ang)
        pts[i].y = r * sin(ang)
    }
    return pts
}

fun dist2(a: Point, b: Point): Double {
    val x = a.x - b.x
    val y = a.y - b.y
    return x * x + y * y
}

fun nearest(pt: Point, cent: LPoint, nCluster: Int): Pair<Int, Double> {
    var minD = hugeVal
    var minI = pt.group
    for (i in 0 until nCluster) {
        val d = dist2(cent[i], pt)
        if (minD > d) {
            minD = d
            minI = i
        }
    }
    return minI to minD
}

fun kpp(pts: LPoint, len: Int, cent: MLPoint) {
    val nCent = cent.size
    val d = DoubleArray(len)
    cent[0] = pts[rand() % len].copy()
    for (nCluster in 1 until nCent) {
        var sum = 0.0
        for (j in 0 until len) {
            d[j] = nearest(pts[j], cent, nCluster).second
            sum += d[j]
        }
        sum = randf(sum)
        for (j in 0 until len) {
            sum -= d[j]
            if (sum > 0.0) continue
            cent[nCluster] = pts[j].copy()
            break
        }
    }
    for (j in 0 until len) pts[j].group = nearest(pts[j], cent, nCent).first
}

fun lloyd(pts: LPoint, len: Int, nCluster: Int): LPoint {
    val cent = MutableList(nCluster) { origin }
    kpp(pts, len, cent)
    do {
        /* group element for centroids are used as counters */
        for (i in 0 until nCluster) {
            with (cent[i]) { x = 0.0; y = 0.0; group = 0 }
        }
        for (j in 0 until len) {
            val p = pts[j]
            val c = cent[p.group]
            with (c) { group++; x += p.x; y += p.y }
        }
        for (i in 0 until nCluster) {
            val c = cent[i]
            c.x /= c.group
            c.y /= c.group
        }
        var changed = 0

        /* find closest centroid of each point */
        for (j in 0 until len) {
            val p = pts[j]
            val minI = nearest(p, cent, nCluster).first
            if (minI != p.group) {
                changed++
                p.group = minI
            }
        }
    }
    while (changed > (len shr 10))  /* stop when 99.9% of points are good */

    for (i in 0 until nCluster) cent[i].group = i
    return cent
}

fun printEps(pts: LPoint, len: Int, cent: LPoint, nCluster: Int) {
    val colors = DoubleArray(nCluster * 3)
    for (i in 0 until nCluster) {
        colors[3 * i + 0] = (3 * (i + 1) % 11) / 11.0
        colors[3 * i + 1] = (7 * i % 11) / 11.0
        colors[3 * i + 2] = (9 * i % 11) / 11.0
    }
    var minX = hugeVal
    var minY = hugeVal
    var maxX = -hugeVal
    var maxY = -hugeVal
    for (j in 0 until len) {
        val p = pts[j]
        if (maxX < p.x) maxX = p.x
        if (minX > p.x) minX = p.x
        if (maxY < p.y) maxY = p.y
        if (minY > p.y) minY = p.y
    }
    val scale = minOf(W / (maxX - minX), H / (maxY - minY))
    val cx = (maxX + minX) / 2.0
    val cy = (maxY + minY) / 2.0

    print("%%!PS-Adobe-3.0\n%%%%BoundingBox: -5 -5 %${W + 10} ${H + 10}\n")
    print("/l {rlineto} def /m {rmoveto} def\n")
    print("/c { .25 sub exch .25 sub exch .5 0 360 arc fill } def\n")
    print("/s { moveto -2 0 m 2 2 l 2 -2 l -2 -2 l closepath ")
    print("	gsave 1 setgray fill grestore gsave 3 setlinewidth")
    print(" 1 setgray stroke grestore 0 setgray stroke }def\n")
    val f1 = "%g %g %g setrgbcolor"
    val f2 = "%.3f %.3f c"
    val f3 = "\n0 setgray %g %g s"
    for (i in 0 until nCluster) {
        val c = cent[i]
        println(f1.format(colors[3 * i], colors[3 * i + 1], colors[3 * i + 2]))
        for (j in 0 until len) {
            val p = pts[j]
            if (p.group != i) continue
            println(f2.format((p.x - cx) * scale + W / 2, (p.y - cy) * scale + H / 2))
        }
        println(f3.format((c.x - cx) * scale + W / 2, (c.y - cy) * scale + H / 2))
    }
    print("\n%%%%EOF")
}

fun main(args: Array<String>) {
    val v = genXY(PTS, 10.0)
    val c = lloyd(v, PTS, K)
    printEps(v, PTS, c, K)
}
