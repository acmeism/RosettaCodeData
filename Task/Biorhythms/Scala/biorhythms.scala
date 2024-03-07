import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import scala.collection.JavaConverters._

object Biorythms extends App {

  val datePairs = List(
    List("1943-03-09", "1972-07-11"),
    List("1809-01-12", "1863-11-19"),
    List("1809-02-12", "1863-11-19")
  )

  datePairs.foreach(biorhythms)

  def biorhythms(aDatePair: List[String]): Unit = {
    val formatter = DateTimeFormatter.ISO_LOCAL_DATE
    val birthDate = LocalDate.parse(aDatePair.head, formatter)
    val targetDate = LocalDate.parse(aDatePair(1), formatter)
    val daysBetween = ChronoUnit.DAYS.between(birthDate, targetDate).toInt
    println(s"Birth date $birthDate, Target date $targetDate")
    println(s"Days between: $daysBetween")

    for (cycle <- Cycle.values) {
      val cycleLength = cycle.length
      val positionInCycle = daysBetween % cycleLength
      val quadrantIndex = 4 * positionInCycle / cycleLength
      val percentage = Math.round(100 * Math.sin(2 * Math.PI * positionInCycle / cycleLength)).toInt

      val description = if (percentage > 95) {
        "peak"
      } else if (percentage < -95) {
        "valley"
      } else if (Math.abs(percentage) < 5) {
        "critical transition"
      } else {
        val daysToTransition = (cycleLength * (quadrantIndex + 1) / 4) - positionInCycle
        val transitionDate = targetDate.plusDays(daysToTransition)
        val descriptions = cycle.descriptions(quadrantIndex).asScala
        val trend = descriptions.head
        val nextTransition = descriptions(1)
        s"$percentage% ($trend, next $nextTransition $transitionDate)"
      }

      println(s"${cycle} day $positionInCycle: $description")
    }
    println()
  }

  enum Cycle(val length: Int) {
    case PHYSICAL extends Cycle(23)
    case EMOTIONAL extends Cycle(28)
    case MENTAL extends Cycle(33)

    def descriptions(number: Int): java.util.List[String] = Cycle.DESCRIPTIONS.get(number)
  }

  object Cycle {
    private val DESCRIPTIONS = java.util.List.of(
      java.util.List.of("up and rising", "peak"),
      java.util.List.of("up but falling", "transition"),
      java.util.List.of("down and falling", "valley"),
      java.util.List.of("down but rising", "transition")
    )
  }

}
