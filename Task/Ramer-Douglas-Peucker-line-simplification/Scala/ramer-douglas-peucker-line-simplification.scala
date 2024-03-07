// version 1.1.0

object SimplifyPolyline extends App {
  type Point = (Double, Double)

  def perpendicularDistance(
      pt: Point,
      lineStart: Point,
      lineEnd: Point
  ): Double = {
    var dx = lineEnd._1 - lineStart._1
    var dy = lineEnd._2 - lineStart._2

    // Normalize
    val mag = math.hypot(dx, dy)
    if (mag > 0.0) { dx /= mag; dy /= mag }
    val pvx = pt._1 - lineStart._1
    val pvy = pt._2 - lineStart._2

    // Get dot product (project pv onto normalized direction)
    val pvdot = dx * pvx + dy * pvy

    // Scale line direction vector and subtract it from pv
    val ax = pvx - pvdot * dx
    val ay = pvy - pvdot * dy

    math.hypot(ax, ay)
  }

  def RamerDouglasPeucker(
      pointList: List[Point],
      epsilon: Double
  ): List[Point] = {
    if (pointList.length < 2)
      throw new IllegalArgumentException("Not enough points to simplify")

    // Check if there are points to process
    if (pointList.length > 2) {
      // Find the point with the maximum distance from the line between the first and last
      val (dmax, index) = pointList.zipWithIndex
        .slice(1, pointList.length - 1)
        .map { case (point, i) =>
          (perpendicularDistance(point, pointList.head, pointList.last), i)
        }
        .maxBy(_._1)

      // If max distance is greater than epsilon, recursively simplify
      if (dmax > epsilon) {
        val firstLine = pointList.take(index + 1)
        val lastLine = pointList.drop(index)
        val recResults1 = RamerDouglasPeucker(firstLine, epsilon)
        val recResults2 = RamerDouglasPeucker(lastLine, epsilon)

        // Combine the results
        (recResults1.init ++ recResults2).distinct
      } else {
        // If no point is further than epsilon, return the endpoints
        List(pointList.head, pointList.last)
      }
    } else {
      // If there are only two points, just return them
      pointList
    }
  }

  val pointList = List(
    (0.0, 0.0),
    (1.0, 0.1),
    (2.0, -0.1),
    (3.0, 5.0),
    (4.0, 6.0),
    (5.0, 7.0),
    (6.0, 8.1),
    (7.0, 9.0),
    (8.0, 9.0),
    (9.0, 9.0)
  )

  val simplifiedPointList = RamerDouglasPeucker(pointList, 1.0)
  println("Points remaining after simplification:")
  simplifiedPointList.foreach(println)
}
