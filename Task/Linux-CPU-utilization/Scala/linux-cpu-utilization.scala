import scala.io.Source
import scala.util.{Try, Success, Failure}

object CpuUtilization {
  def main(args: Array[String]): Unit = {
    Try {
      val percentages = parseUtilization(procStat())
      println(f"${"idle".padTo(10, ' ')} ${percentages(0) * 100}%.2f%%")
      println(f"${"not-idle".padTo(10, ' ')} ${percentages(1) * 100}%.2f%%")
    } match {
      case Success(_) => // Success case handled above
      case Failure(error) => Console.err.println(s"Error: ${error.getMessage}")
    }
  }

  def procStat(): String = {
    val source = Source.fromFile("/proc/stat")
    try {
      source.getLines().next()
    } finally {
      source.close()
    }
  }

  /**
   * Parses the proc/stat line to extract CPU utilization percentages
   * @param string The proc/stat line to parse
   * @return Array containing idle and not-idle percentage values
   */
  def parseUtilization(string: String): Array[Double] = {
    val trimmed = string.substring(4).trim
    var total = 0.0
    var idle = 0.0

    val values = trimmed.split(" ").zipWithIndex

    for ((value, index) <- values) {
      val num = value.toInt
      if (index == 3) {
        idle = num
      }
      total += num
    }

    val idlePercentage = idle / total
    val notIdlePercentage = 1 - idlePercentage

    Array(idlePercentage, notIdlePercentage)
  }
}
