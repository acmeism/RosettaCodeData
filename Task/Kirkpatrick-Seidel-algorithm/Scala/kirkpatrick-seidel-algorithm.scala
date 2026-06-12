import scala.util.Random
import scala.collection.mutable
import scala.math.Ordering

object ConvexHullAlgorithm {
  case class Point(x: Double, y: Double) extends Ordered[Point] {
    override def compare(other: Point): Int = {
      if (this.x == other.x) {
        this.y.compare(other.y)
      } else {
        this.x.compare(other.x)
      }
    }

    // Custom comparison methods for clarity
    def isLessThan(other: Point): Boolean = {
      if (this.x == other.x) {
        this.y < other.y
      } else {
        this.x < other.x
      }
    }

    def isGreaterThan(other: Point): Boolean = {
      if (this.x == other.x) {
        this.y > other.y
      } else {
        this.x > other.x
      }
    }
  }

  private val rand = new Random()

  private def flipped(points: Iterable[Point]): List[Point] = {
    points.map(point => Point(-point.x, -point.y)).toList
  }

  private def quickSelect[T](ls: mutable.Buffer[T], index: Int)(implicit ord: Ordering[T]): T = {
    quickSelect(ls, index, 0, ls.size - 1)
  }

  private def quickSelect[T](ls: mutable.Buffer[T], index: Int, lo: Int, hi: Int)(implicit ord: Ordering[T]): T = {
    if (lo == hi) {
      return ls(lo)
    }

    val pivotIndex = lo + rand.nextInt(hi - lo + 1)
    val pivotValue = ls(pivotIndex)
    swap(ls, lo, pivotIndex)

    var cur = lo
    for (run <- lo + 1 to hi) {
      if (ord.lt(ls(run), pivotValue)) {
        cur += 1
        swap(ls, cur, run)
      }
    }

    swap(ls, cur, lo)

    if (index < cur) {
      quickSelect(ls, index, lo, cur - 1)
    } else if (index > cur) {
      quickSelect(ls, index, cur + 1, hi)
    } else {
      ls(cur)
    }
  }

  private def swap[T](list: mutable.Buffer[T], i: Int, j: Int): Unit = {
    val temp = list(i)
    list(i) = list(j)
    list(j) = temp
  }

  private def bridge(points: Set[Point], verticalLine: Double): Array[Point] = {
    val candidates = mutable.HashSet[Point]()

    if (points.size == 2) {
      val pointList = points.toList.sorted
      return Array(pointList.head, pointList.last)
    }

    val pairs = mutable.ArrayBuffer[Array[Point]]()
    val modifyList = points.toList

    for (i <- 0 until (modifyList.size / 2 * 2) by 2) {
      val p1 = modifyList(i)
      val p2 = modifyList(i + 1)
      if (p1.isLessThan(p2)) {
        pairs += Array(p1, p2)
      } else {
        pairs += Array(p2, p1)
      }
    }

    if (modifyList.size % 2 == 1) {
      candidates += modifyList.last
    }

    val slopes = mutable.ArrayBuffer[Double]()
    val validPairs = mutable.ArrayBuffer[Array[Point]]()

    for (pair <- pairs) {
      if (pair(0).x == pair(1).x) {
        candidates += (if (pair(0).y > pair(1).y) pair(0) else pair(1))
      } else {
        slopes += ((pair(0).y - pair(1).y) / (pair(0).x - pair(1).x))
        validPairs += pair
      }
    }

    if (slopes.isEmpty) {
      if (candidates.size >= 2) {
        val candidateList = candidates.toList.sorted
        return Array(candidateList.head, candidateList.last)
      }
      // If we don't have enough candidates, return the first pair
      val pointList = points.toList
      return Array(pointList(0), pointList(1))
    }

    val medianIndex = slopes.size / 2 - (if (slopes.size % 2 == 0) 1 else 0)
    val medianSlope: Double = quickSelect(slopes, medianIndex)

    val small = mutable.HashSet[Array[Point]]()
    val equal = mutable.HashSet[Array[Point]]()
    val large = mutable.HashSet[Array[Point]]()

    for (i <- slopes.indices) {
      if (slopes(i) < medianSlope) {
        small += validPairs(i)
      } else if (slopes(i) == medianSlope) {
        equal += validPairs(i)
      } else {
        large += validPairs(i)
      }
    }

    var maxIntercept = Double.NegativeInfinity
    for (point <- points) {
      maxIntercept = math.max(maxIntercept, point.y - medianSlope * point.x)
    }

    val maxSet = mutable.ArrayBuffer[Point]()
    for (point <- points) {
      if (point.y - medianSlope * point.x == maxIntercept) {
        maxSet += point
      }
    }

    val left = maxSet.min
    val right = maxSet.max

    if (left.x <= verticalLine && right.x > verticalLine) {
      return Array(left, right)
    }

    if (right.x <= verticalLine) {
      for (pair <- large) {
        candidates += pair(1)
      }
      for (pair <- equal) {
        candidates += pair(1)
      }
      for (pair <- small) {
        candidates += pair(0)
        candidates += pair(1)
      }
    }

    if (left.x > verticalLine) {
      for (pair <- small) {
        candidates += pair(0)
      }
      for (pair <- equal) {
        candidates += pair(0)
      }
      for (pair <- large) {
        candidates += pair(0)
        candidates += pair(1)
      }
    }

    bridge(candidates.toSet, verticalLine)
  }

  private def connect(lower: Point, upper: Point, points: Set[Point]): List[Point] = {
    if (lower == upper) {
      return List(lower)
    }

    val pointsVec = points.toList.sorted
    val midIndex = (pointsVec.size - 1) / 2

    val maxLeft = quickSelect(mutable.ArrayBuffer.from(pointsVec), midIndex)
    val minRight = quickSelect(mutable.ArrayBuffer.from(pointsVec), midIndex + 1)

    val bridgePoints = bridge(points, (maxLeft.x + minRight.x) / 2)
    val left = bridgePoints(0)
    val right = bridgePoints(1)

    val pointsLeft = mutable.HashSet(left)
    val pointsRight = mutable.HashSet(right)

    for (point <- points) {
      if (point.x < left.x) {
        pointsLeft += point
      } else if (point.x > right.x) {
        pointsRight += point
      }
    }

    val leftResult = connect(lower, left, pointsLeft.toSet)
    val rightResult = connect(right, upper, pointsRight.toSet)

    leftResult ++ rightResult
  }

  private def upperHull(points: Set[Point]): List[Point] = {
    var lower = points.min

    // Find the lowest point with the same x-coordinate as the minimum
    for (point <- points) {
      if (point.x == lower.x && point.y > lower.y) {
        lower = point
      }
    }

    val upper = points.max

    val filteredPoints = mutable.HashSet(lower, upper)
    for (p <- points) {
      if (lower.x < p.x && p.x < upper.x) {
        filteredPoints += p
      }
    }

    connect(lower, upper, filteredPoints.toSet)
  }

  def convexHull(points: Set[Point]): List[Point] = {
    val upper = upperHull(points)

    val flippedPoints = points.map(p => Point(-p.x, -p.y))
    val flippedUpper = upperHull(flippedPoints)
    val lower = flipped(flippedUpper)

    // Remove duplicate points at the start/end
    val (adjustedUpper, adjustedLower) = if (upper.nonEmpty && lower.nonEmpty) {
      val upperToKeep = if (upper.last == lower.head) upper.dropRight(1) else upper
      val lowerToKeep = if (upper.head == lower.last) lower.dropRight(1) else lower
      (upperToKeep, lowerToKeep)
    } else {
      (upper, lower)
    }

    adjustedUpper ++ adjustedLower
  }

  def main(args: Array[String]): Unit = {
    // Create points for a 2D projection of a 3D simplex
    val points = Set(
      Point(0.0, 0.0),   // projection of [0.0, 0.0, 0.0]
      Point(1.0, 0.0),   // projection of [1.0, 0.0, 0.0]
      Point(0.0, 1.0),   // projection of [0.0, 1.0, 0.0]
      Point(0.5, 0.5)    // projection of [0.0, 0.0, 1.0] (projected to 2D)
    )

    println("Input points:")
    for (p <- points) {
      println(s"(${p.x}, ${p.y})")
    }

    val hull = convexHull(points)

    println("\nConvex hull points:")
    for (p <- hull) {
      println(s"(${p.x}, ${p.y})")
    }
  }
}
