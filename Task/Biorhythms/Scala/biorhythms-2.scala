import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import scala.jdk.CollectionConverters._

object Biorhythms extends App {

  private val datePairs = List(
    ("1943-03-09", "1972-07-11"),
    ("1809-01-12", "1863-11-19"),
    ("1809-02-12", "1863-11-19")
  )

  datePairs.foreach(calculateBiorhythms)

  private def calculateBiorhythms(dates: (String, String)): Unit = {
    val formatter = DateTimeFormatter.ISO_LOCAL_DATE
    val birthDate = LocalDate.parse(dates._1, formatter)
    val targetDate = LocalDate.parse(dates._2, formatter)
    val daysBetween = ChronoUnit.DAYS.between(birthDate, targetDate).toInt

    println(s"Birth Date: $birthDate, Target Date: $targetDate")
    println(s"Days Between: $daysBetween")

    Cycle.values.foreach(processCycle(daysBetween, targetDate, _))

    println()
  }

  private def processCycle(daysBetween: Int, targetDate: LocalDate, cycle: Cycle): Unit = {
    val position = daysBetween % cycle.length
    val angle = 2 * Math.PI * position / cycle.length
    val percentage = Math.round(100 * Math.sin(angle)).toInt

    val description = percentage match {
      case p if p > 95 => "peak"
      case p if p < -95 => "valley"
      case p if Math.abs(p) < 5 => "critical transition"
      case _ =>
        val quadrant = Quadrant.fromPosition(position, cycle.length)
        val daysToTransition = quadrant.daysToTransition(position, cycle.length)
        val transitionDate = targetDate.plusDays(daysToTransition)
        val (trend, nextTransition) = quadrant.getDescriptions
        s"$percentage% ($trend, $nextTransition on $transitionDate)"
    }

    println(s"${cycle} day $position: $description")
  }

  private enum Cycle(val length: Int) {
    private case PHYSICAL extends Cycle(23)
    private case EMOTIONAL extends Cycle(28)
    private case MENTAL extends Cycle(33)

    override def toString: String = this match {
      case PHYSICAL => "Physical"
      case EMOTIONAL => "Emotional"
      case MENTAL => "Mental"
    }
  }

  enum Quadrant {
    case UpAndRising
    case UpButFalling
    case DownAndFalling
    case DownButRising

    def getDescriptions: (String, String) = this match {
      case UpAndRising => ("up and rising", "next peak")
      case UpButFalling => ("up but falling", "next transition")
      case DownAndFalling => ("down and falling", "next valley")
      case DownButRising => ("down but rising", "next transition")
    }

    def daysToTransition(position: Int, cycleLength: Int): Int = {
      val quarter = cycleLength / 4
      val positionInQuadrant = position % quarter
      quarter - positionInQuadrant
    }
  }

  private object Quadrant {
    def fromPosition(position: Int, cycleLength: Int): Quadrant = {
      val relativePosition = position.toDouble / cycleLength
      relativePosition match {
        case p if p >= 0.0 && p < 0.25 => Quadrant.UpAndRising
        case p if p >= 0.25 && p < 0.5 => Quadrant.UpButFalling
        case p if p >= 0.5 && p < 0.75 => Quadrant.DownAndFalling
        case p if p >= 0.75 && p < 1.0 => Quadrant.DownButRising
        case _ => throw new IllegalArgumentException("Position out of bounds")
      }
    }
  }
}
