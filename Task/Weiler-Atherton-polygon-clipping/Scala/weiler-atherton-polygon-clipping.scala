import scala.collection.mutable.ArrayBuffer
import scala.collection.mutable.ListBuffer
import scala.util.{Try, Success, Failure}
import scala.util.control.Breaks._

object PolygonClipper {

  def isInPolygon(point: Point, poly: Polygon): Boolean = {
    val x = point.x
    val y = point.y
    var inside = false
    var j = poly.points.length - 1

    for (i <- poly.points.indices) {
      val xi = poly.points(i).x
      val yi = poly.points(i).y
      val xj = poly.points(j).x
      val yj = poly.points(j).y

      val intersect = ((yi > y) != (yj > y)) &&
                      (x < (xj - xi).toDouble * (y - yi) / (yj - yi) + xi)

      if (intersect) {
        inside = !inside
      }

      j = i
    }

    inside
  }

  def distanceCmp(self: Point, first: Point, second: Point): Int = {
    val dstFirst = Math.abs(self.x - first.x) + Math.abs(self.y - first.y)
    val dstSecond = Math.abs(self.x - second.x) + Math.abs(self.y - second.y)

    if (dstFirst < dstSecond) -1
    else if (dstFirst > dstSecond) 1
    else 0
  }

  def isInLine(point: Point, line: Line): Boolean = {
    val dxc = point.x - line.start.x
    val dyc = point.y - line.start.y

    val dxl = line.end.x - line.start.x
    val dyl = line.end.y - line.start.y

    val cross = dxc * dyl - dyc * dxl

    if (cross != 0) {
      return false
    }

    if (Math.abs(dxl) >= Math.abs(dyl)) {
      if (dxl > 0) {
        line.start.x <= point.x && point.x <= line.end.x
      } else {
        line.end.x <= point.x && point.x <= line.start.x
      }
    } else {
      if (dyl > 0) {
        line.start.y <= point.y && point.y <= line.end.y
      } else {
        line.end.y <= point.y && point.y <= line.start.y
      }
    }
  }

  def getIntersection(self: Line, line: Line): Option[Point] = {
    val line1Start = self.start
    val line1End = self.end
    val line2Start = line.start
    val line2End = line.end

    val den = ((line2End.y - line2Start.y) * (line1End.x - line1Start.x)) -
              ((line2End.x - line2Start.x) * (line1End.y - line1Start.y))

    if (den == 0) {
      return None
    }

    val a = line1Start.y - line2Start.y
    val b = line1Start.x - line2Start.x

    val num1 = ((line2End.x - line2Start.x) * a) - ((line2End.y - line2Start.y) * b)
    val num2 = ((line1End.x - line1Start.x) * a) - ((line1End.y - line1Start.y) * b)

    val aF = num1.toDouble / den.toDouble
    val bF = num2.toDouble / den.toDouble

    if (aF < 0.0 || aF > 1.0 || bF < 0.0 || bF > 1.0) {
      return None
    }

    val result = Point(
      line1Start.x + Math.round(aF * (line1End.x - line1Start.x)).toInt,
      line1Start.y + Math.round(aF * (line1End.y - line1Start.y)).toInt
    )

    Some(result)
  }

  def isClockwise(poly: Polygon): Boolean = {
    var sum = 0
    for (i <- poly.points.indices) {
      val j = if (i != poly.points.length - 1) i + 1 else 0
      sum += (poly.points(j).x - poly.points(i).x) * (poly.points(j).y + poly.points(i).y)
    }
    sum < 0
  }

  def getReversed(poly: Polygon): Polygon = {
    Polygon(poly.points.reverse)
  }

  def getFirstOutsideVertexIndex(subject: Polygon, poly: Polygon): Option[Int] = {
    for (i <- subject.points.indices) {
      if (!isInPolygon(subject.points(i), poly)) {
        return Some(i)
      }
    }
    None
  }

  def getFirstInsideVertexIndex(subject: Polygon, poly: Polygon): Option[Int] = {
    for (i <- subject.points.indices) {
      if (isInPolygon(subject.points(i), poly)) {
        return Some(i)
      }
    }
    None
  }

  def getIntersectionsWithLine(poly: Polygon, line: Line, cursorInside: Array[Boolean]): List[InterVertex] = {
    val intersections = ListBuffer[Point]()

    for (i <- poly.points.indices) {
      val start = poly.points(i)
      val nextI = if (i == poly.points.length - 1) 0 else i + 1
      val end = poly.points(nextI)

      val l = Line(start, end)
      val intersection = getIntersection(l, line)

      intersection match {
        case Some(point) =>
          if (!point.equals(line.start) &&
              !point.equals(line.end) &&
              !point.equals(start) &&
              !point.equals(end)) {
            intersections += point
          }
        case None => ()
      }
    }

    val sortedIntersections = intersections.sortWith((a, b) => distanceCmp(line.start, a, b) < 0)

    val result = ListBuffer[InterVertex]()
    for (x <- sortedIntersections) {
      if (cursorInside(0)) {
        cursorInside(0) = !cursorInside(0)
        result += InterVertex(InterVertexType.OutIntersection, x)
      } else {
        cursorInside(0) = !cursorInside(0)
        result += InterVertex(InterVertexType.InIntersection, x)
      }
    }

    result.toList
  }

  def getInterVertexList(subject: Polygon, poly: Polygon): PolyListOption = {
    val subjectCopy = if (!isClockwise(subject)) getReversed(subject) else subject

    val cursorInside = Array(false)
    var intersectionCount = 0

    getFirstOutsideVertexIndex(subjectCopy, poly) match {
      case Some(startIndex) =>
        if (getFirstInsideVertexIndex(subjectCopy, poly).isEmpty) {
          var allInside = true
          for (point <- poly.points) {
            if (!isInPolygon(point, subjectCopy)) {
              allInside = false
            }
          }

          if (allInside) {
            return PolyListOption(PolyListOptionType.InsidePoly, List(), poly.points.toList)
          }
        }

        val result = ListBuffer[InterVertex]()

        for (iOffset <- 0 until subjectCopy.points.length) {
          val i = (startIndex + iOffset) % subjectCopy.points.length
          val start = subjectCopy.points(i)

          // Check vertex
          if (i != startIndex && isInPolygon(start, poly)) {
            result += InterVertex(InterVertexType.InsideVertex, start)
          } else {
            result += InterVertex(InterVertexType.OutsideVertex, start)
          }

          // Check intersection
          val nextI = if (i == subjectCopy.points.length - 1) 0 else i + 1
          val end = subjectCopy.points(nextI)
          val line = Line(start, end)

          val intersections = getIntersectionsWithLine(poly, line, cursorInside)
          intersectionCount += intersections.length

          result ++= intersections
        }

        // Check if there are any intersections
        val hasIntersections = result.exists(vertex =>
          vertex.vertexType == InterVertexType.InIntersection ||
          vertex.vertexType == InterVertexType.OutIntersection
        )

        if (!hasIntersections) {
          PolyListOption(PolyListOptionType.None, List(), List())
        } else {
          PolyListOption(PolyListOptionType.List, result.toList, List())
        }

      case None =>
        PolyListOption(PolyListOptionType.InsidePoly, List(), subjectCopy.points.toList)
    }
  }

  case class PointsPair(points: List[Point], lastPoint: Point)

  def collectFromList(list: ListBuffer[InterVertex], startPoint: Point): Option[PointsPair] = {
    var initialVertexNotFound = true
    var lastPoint: Option[Point] = None
    var startI = 0
    var endI = 0
    val dontSkip = list.headOption.exists(_.point == startPoint)

    val points = ListBuffer[Point]()
    var i = 0

    // Skip until InIntersection occurs, but include the InIntersection
    while (i < list.length && initialVertexNotFound && !dontSkip) {
      val next = if (i == list.length - 1) 0 else i + 1
      val nextPoint = list(next)

      if (nextPoint.vertexType == InterVertexType.InIntersection ||
          nextPoint.vertexType == InterVertexType.OutIntersection) {
        if (nextPoint.point == startPoint) {
          startI = next
          initialVertexNotFound = false
        }
      }
      i += 1
    }

    // Collect points
    if (!initialVertexNotFound || dontSkip) {
      i = startI
      var continueCollecting = true

      while (continueCollecting && i < list.length) {
        val vertex = list(i)

        if (vertex.vertexType == InterVertexType.OutIntersection) {
          endI = i
          lastPoint = Some(vertex.point)
          continueCollecting = false
        } else {
          points += vertex.point
        }

        i += 1
      }
    }

    val amount = endI - startI + 1
    if (endI >= startI && startI + amount <= list.length) {
      list.remove(startI, amount)
    }

    if (points.nonEmpty && lastPoint.isDefined) {
      Some(PointsPair(points.toList, lastPoint.get))
    } else {
      None
    }
  }

  def getClipPolygon(
    subject: ListBuffer[InterVertex],
    clip: ListBuffer[InterVertex],
    initial: Point
  ): Option[List[Point]] = {

    val result = ListBuffer[Point]()
    var subjectAsList = true
    var startPoint = initial
    var endPoint = subject.last.point

    while (initial != endPoint) {
      val values = collectFromList(
        if (subjectAsList) subject else clip,
        startPoint
      )

      values match {
        case Some(pair) =>
          endPoint = pair.lastPoint
          startPoint = pair.lastPoint
          subjectAsList = !subjectAsList

          result ++= pair.points

        case None =>
          println("something went wrong")
          println(s"res size: ${result.length}")
          return None
      }
    }

    if (result.nonEmpty) {
      // Filter consecutive duplicate points
      val filtered = result.foldLeft(List[Point]()) { (acc, point) =>
        if (acc.isEmpty || point != acc.head) point :: acc else acc
      }.reverse

      Some(filtered)
    } else {
      None
    }
  }

  def getClipPolygons(
    subject: ListBuffer[InterVertex],
    clip: ListBuffer[InterVertex]
  ): Option[List[List[Point]]] = {

    val result = ListBuffer[List[Point]]()

    while (true) {
      InterVertex.getFirstInIntersection(subject) match {
        case Some(startPoint) =>
          getClipPolygon(subject, clip, startPoint) match {
            case Some(poly) => result += poly
            case None => return if (result.nonEmpty) Some(result.toList) else None
          }
        case None => return if (result.nonEmpty) Some(result.toList) else None
      }
    }

    if (result.nonEmpty) Some(result.toList) else None
  }

  def clip(self: Polygon, other: Polygon): Option[List[List[Point]]] = {
    val option = getInterVertexList(self, other)
    val otherOption = getInterVertexList(other, self)

    option.optionType match {
      case PolyListOptionType.List =>
        val subjectList = ListBuffer[InterVertex]() ++ option.interVertexList

        otherOption.optionType match {
          case PolyListOptionType.List =>
            val clipList = ListBuffer[InterVertex]() ++ otherOption.interVertexList
            getClipPolygons(subjectList, clipList)
          case PolyListOptionType.InsidePoly =>
            Some(List(otherOption.points))
          case PolyListOptionType.None =>
            None
        }
      case PolyListOptionType.InsidePoly =>
        Some(List(option.points))
      case PolyListOptionType.None =>
        None
    }
  }

  // Testing function
  def runTests(): Unit = {
    // Test isInLine
    {
      val p = Point(5, 10)
      val line = Line(Point(5, 5), Point(5, 20))
      val result = isInLine(p, line)
      println(s"isInLine test 1: ${if (result) "PASS" else "FAIL"}")

      val pF = Point(3, 4)
      val lineF = Line(Point(5, 5), Point(5, 20))
      val resultF = isInLine(pF, lineF)
      println(s"isInLine test 2: ${if (!resultF) "PASS" else "FAIL"}")
    }

    // Test clip
    {
      val polyPoints = Array(
        Point(180, 420),
        Point(180, 120),
        Point(520, 120),
        Point(520, 420),
        Point(420, 420),
        Point(320, 220)
      )
      val poly = Polygon(polyPoints)

      val interPoints = Array(
        Point(60, 220),
        Point(330, 120),
        Point(410, 290),
        Point(80, 480),
        Point(280, 280)
      )
      val interPolygon = Polygon(interPoints)

      clip(poly, interPolygon) match {
        case Some(polygons) if polygons.nonEmpty =>
          println(s"clip test: PASS - Found ${polygons.length} polygons")

          // Print first polygon points
          if (polygons.head.nonEmpty) {
            println("First polygon points:")
            for (p <- polygons.head) {
              println(s"  Point: (${p.x}, ${p.y})")
            }
          }
        case _ =>
          println("clip test: FAIL - No polygons found")
      }
    }
  }

  def main(args: Array[String]): Unit = {
    runTests()
  }
}

case class Point(x: Int, y: Int)

case class Line(start: Point, end: Point)

case class Polygon(points: Array[Point])

object InterVertexType extends Enumeration {
  type InterVertexType = Value
  val InsideVertex, OutsideVertex, InIntersection, OutIntersection = Value
}
import InterVertexType._

case class InterVertex(vertexType: InterVertexType, point: Point)

object InterVertex {
  def getFirstInIntersection(list: ListBuffer[InterVertex]): Option[Point] = {
    var found = -1
    var result: Option[Point] = None

    breakable({
    for (i <- list.indices) {
      if (list(i).vertexType == InIntersection) {
        found = i
        result = Some(list(i).point)
        break
      }
    }
    });

    if (found > 0) {
      list.remove(0, found)
    }

    result
  }
}

object PolyListOptionType extends Enumeration {
  type PolyListOptionType = Value
  val List, InsidePoly, None = Value
}
import PolyListOptionType._

case class PolyListOption(optionType: PolyListOptionType, interVertexList: List[InterVertex], points: List[Point])
