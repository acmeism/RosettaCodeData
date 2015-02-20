trait MeanAnglesComputation {
  import scala.math.{Pi, atan2, cos, sin}

  def meanAngle(angles: List[Double], convFactor: Double = 180.0 / Pi) = {
    val sums = angles.foldLeft((.0, .0))((r, c) => {
      val rads = c / convFactor
      (r._1 + sin(rads), r._2 + cos(rads))
    })
    val result = atan2(sums._1, sums._2)
    (result + (if (result.signum == -1) 2 * Pi else 0.0)) * convFactor
  }
}

object MeanAngles extends App with MeanAnglesComputation {
  assert(meanAngle(List(350, 10), 180.0 / math.Pi).round == 360, "Unexpected result with 350, 10")
  assert(meanAngle(List(90, 180, 270, 360)).round == 270, "Unexpected result with 90, 180, 270, 360")
  assert(meanAngle(List(10, 20, 30)).round == 20, "Unexpected result with 10, 20, 30")
  println("Successfully completed without errors.")
}
