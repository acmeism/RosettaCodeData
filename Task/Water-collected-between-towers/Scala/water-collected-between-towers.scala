import scala.collection.parallel.CollectionConverters.VectorIsParallelizable

// Program to find maximum amount of water
// that can be trapped within given set of bars.
object TrappedWater extends App {
  private val barLines = List(
    Vector(1, 5, 3, 7, 2),
    Vector(5, 3, 7, 2, 6, 4, 5, 9, 1, 2),
    Vector(2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1),
    Vector(5, 5, 5, 5),
    Vector(5, 6, 7, 8),
    Vector(8, 7, 7, 6),
    Vector(6, 7, 10, 7, 6)).zipWithIndex

  // Method for maximum amount of water
  private def sqBoxWater(barHeights: Vector[Int]): Int = {
    def maxOfLeft = barHeights.par.scanLeft(0)(math.max).tail
    def maxOfRight = barHeights.par.scanRight(0)(math.max).init

    def waterlevels = maxOfLeft.zip(maxOfRight)
      .map { case (maxL, maxR) => math.min(maxL, maxR) }

    waterlevels.zip(barHeights).map { case (level, towerHeight) => level - towerHeight }.sum
  }

  barLines.foreach(barSet =>
    println(s"Block ${barSet._2 + 1} could hold max. ${sqBoxWater(barSet._1)} units."))

}
