import java.util.*
import kotlin.collections.HashSet
import kotlin.math.max

class ConvexHullAlgorithm {

    data class Point(var x: Double, var y: Double) : Comparable<Point> {
        constructor() : this(0.0, 0.0)

        override fun compareTo(other: Point): Int {
            return if (this.x == other.x) {
                this.y.compareTo(other.y)
            } else {
                this.x.compareTo(other.x)
            }
        }

        override fun equals(other: Any?): Boolean {
            if (this === other) return true
            if (other == null || this::class != other::class) return false
            val point = other as Point
            return this.x.compareTo(point.x) == 0 && this.y.compareTo(point.y) == 0
        }

        override fun hashCode(): Int {
            return Objects.hash(x, y)
        }

        fun isLessThan(other: Point): Boolean {
            return if (this.x == other.x) {
                this.y < other.y
            } else {
                this.x < other.x
            }
        }

        fun isGreaterThan(other: Point): Boolean {
            return if (this.x == other.x) {
                this.y > other.y
            } else {
                this.x > other.x
            }
        }
    }

    companion object {
        private val rand = Random()

        private fun flipped(points: Collection<Point>): List<Point> {
            return points.map { Point(-it.x, -it.y) }
        }

        private fun <T : Comparable<T>> quickSelect(ls: MutableList<T>, index: Int): T {
            return quickSelect(ls, index, 0, ls.size - 1)
        }

        private fun <T : Comparable<T>> quickSelect(ls: MutableList<T>, index: Int, lo: Int, hi: Int): T {
            if (lo == hi) {
                return ls[lo]
            }
            val pivotIndex = lo + rand.nextInt(hi - lo + 1)
            val pivotValue = ls[pivotIndex]
            Collections.swap(ls, lo, pivotIndex)
            var cur = lo
            for (run in lo + 1..hi) {
                if (ls[run].compareTo(pivotValue) < 0) {
                    cur++
                    Collections.swap(ls, cur, run)
                }
            }
            Collections.swap(ls, cur, lo)
            return when {
                index < cur -> quickSelect(ls, index, lo, cur - 1)
                index > cur -> quickSelect(ls, index, cur + 1, hi)
                else -> ls[cur]
            }
        }

        private fun bridge(points: Set<Point>, verticalLine: Double): Array<Point> {
            val candidates = mutableSetOf<Point>()
            if (points.size == 2) {
                val pointList = points.toMutableList()
                pointList.sort()
                return arrayOf(pointList[0], pointList[1])
            }

            val pairs = mutableListOf<Array<Point>>()
            val modifyList = points.toMutableList()

            for (i in 0 until modifyList.size / 2 * 2 step 2) {
                val p1 = modifyList[i]
                val p2 = modifyList[i + 1]
                pairs.add(if (p1.isLessThan(p2)) arrayOf(p1, p2) else arrayOf(p2, p1))
            }

            if (modifyList.size % 2 == 1) {
                candidates.add(modifyList.last())
            }

            val slopes = mutableListOf<Double>()
            val validPairs = mutableListOf<Array<Point>>()

            for (pair in pairs) {
                if (pair[0].x == pair[1].x) {
                    candidates.add(if (pair[0].y > pair[1].y) pair[0] else pair[1])
                } else {
                    slopes.add((pair[0].y - pair[1].y) / (pair[0].x - pair[1].x))
                    validPairs.add(pair)
                }
            }

            if (slopes.isEmpty()) {
                if (candidates.size >= 2) {
                    val candidateList = candidates.toMutableList()
                    candidateList.sort()
                    return arrayOf(candidateList[0], candidateList.last())
                }
                // If we don't have enough candidates, return the first pair
                val pointList = points.toMutableList()
                return arrayOf(pointList[0], pointList[1])
            }

            val medianIndex = slopes.size / 2 - if (slopes.size % 2 == 0) 1 else 0
            val medianSlope = quickSelect(slopes, medianIndex)

            val small = mutableSetOf<Array<Point>>()
            val equal = mutableSetOf<Array<Point>>()
            val large = mutableSetOf<Array<Point>>()

            for (i in slopes.indices) {
                when {
                    slopes[i] < medianSlope -> small.add(validPairs[i])
                    slopes[i] == medianSlope -> equal.add(validPairs[i])
                    else -> large.add(validPairs[i])
                }
            }

            var maxIntercept = Double.NEGATIVE_INFINITY
            for (point in points) {
                maxIntercept = max(maxIntercept, point.y - medianSlope * point.x)
            }

            val maxSet = mutableListOf<Point>()
            for (point in points) {
                if (point.y - medianSlope * point.x == maxIntercept) {
                    maxSet.add(point)
                }
            }

            val left = Collections.min(maxSet)
            val right = Collections.max(maxSet)

            if (left.x <= verticalLine && right.x > verticalLine) {
                return arrayOf(left, right)
            }

            if (right.x <= verticalLine) {
                for (pair in large) {
                    candidates.add(pair[1])
                }
                for (pair in equal) {
                    candidates.add(pair[1])
                }
                for (pair in small) {
                    candidates.add(pair[0])
                    candidates.add(pair[1])
                }
            }

            if (left.x > verticalLine) {
                for (pair in small) {
                    candidates.add(pair[0])
                }
                for (pair in equal) {
                    candidates.add(pair[0])
                }
                for (pair in large) {
                    candidates.add(pair[0])
                    candidates.add(pair[1])
                }
            }

            return bridge(candidates, verticalLine)
        }

        private fun connect(lower: Point, upper: Point, points: Set<Point>): List<Point> {
            if (lower == upper) {
                return listOf(lower)
            }

            val pointsVec = points.toMutableList()
            pointsVec.sort()

            val midIndex = (pointsVec.size - 1) / 2
            val maxLeft = quickSelect(pointsVec, midIndex)
            val minRight = quickSelect(pointsVec, midIndex + 1)

            val bridgePoints = bridge(points, (maxLeft.x + minRight.x) / 2)
            val left = bridgePoints[0]
            val right = bridgePoints[1]

            val pointsLeft = mutableSetOf(left)
            val pointsRight = mutableSetOf(right)

            for (point in points) {
                when {
                    point.x < left.x -> pointsLeft.add(point)
                    point.x > right.x -> pointsRight.add(point)
                }
            }

            val leftResult = connect(lower, left, pointsLeft)
            val rightResult = connect(right, upper, pointsRight)

            return leftResult + rightResult
        }

        private fun upperHull(points: Set<Point>): List<Point> {
            val lower = Collections.min(points)
            // Find the lowest point with the same x-coordinate as the minimum
            for (point in points) {
                if (point.x == lower.x && point.y > lower.y) {
                    lower.y = point.y
                }
            }

            val upper = Collections.max(points)
            val filteredPoints = mutableSetOf(lower, upper)

            for (p in points) {
                if (lower.x < p.x && p.x < upper.x) {
                    filteredPoints.add(p)
                }
            }

            return connect(lower, upper, filteredPoints)
        }

        fun convexHull(points: Set<Point>): List<Point> {
            val upper = upperHull(points).toMutableList()
            val flippedPoints = points.map { Point(-it.x, -it.y) }.toSet()
            val flippedUpper = upperHull(flippedPoints)
            val lower = flipped(flippedUpper).toMutableList()

            // Remove duplicate points at the start/end
            if (upper.isNotEmpty() && lower.isNotEmpty()) {
                if (upper.last() == lower.first()) {
                    upper.removeAt(upper.size - 1)
                }
                if (upper.first() == lower.last()) {
                    lower.removeAt(lower.size - 1)
                }
            }

            return upper + lower
        }
    }
}

fun main() {
    // Create points for a 2D projection of a 3D simplex
    val points = setOf(
        ConvexHullAlgorithm.Point(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
        ConvexHullAlgorithm.Point(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
        ConvexHullAlgorithm.Point(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
        ConvexHullAlgorithm.Point(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
    )

    println("Input points:")
    for (p in points) {
        println("(${p.x}, ${p.y})")
    }

    val hull = ConvexHullAlgorithm.convexHull(points)
    println("\nConvex hull points:")
    for (p in hull) {
        println("(${p.x}, ${p.y})")
    }
}

