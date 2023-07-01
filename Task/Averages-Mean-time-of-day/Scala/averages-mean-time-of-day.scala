import java.time.LocalTime
import scala.compat.Platform

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

object MeanBatTime extends App with MeanAnglesComputation {
  val dayInSeconds = 60 * 60 * 24

  def times = batTimes.map(t => afterMidnight(t).toDouble)

  def afterMidnight(twentyFourHourTime: String) = {
    val t = LocalTime.parse(twentyFourHourTime)
    (if (t.isBefore(LocalTime.NOON)) dayInSeconds else 0) + LocalTime.parse(twentyFourHourTime).toSecondOfDay
  }

  def batTimes = List("23:00:17", "23:40:20", "00:12:45", "00:17:19")
  assert(LocalTime.MIN.plusSeconds(meanAngle(times, dayInSeconds).round).toString == "23:47:40")
  println(s"Successfully completed without errors. [total ${Platform.currentTime - executionStart} ms]")
}
