import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.temporal.ChronoUnit
import kotlin.math.roundToInt
import kotlin.math.sin

fun main() {
    val datePairs = listOf(
        listOf("1943-03-09", "1972-07-11"),
        listOf("1809-01-12", "1863-11-19"),
        listOf("1809-02-12", "1863-11-19")
    )

    for (datePair in datePairs) {
        calculateBiorhythms(datePair)
    }
}

fun calculateBiorhythms(datePair: List<String>) {
    val formatter = DateTimeFormatter.ISO_LOCAL_DATE
    val birthDate = LocalDate.parse(datePair[0], formatter)
    val targetDate = LocalDate.parse(datePair[1], formatter)
    val daysBetween = ChronoUnit.DAYS.between(birthDate, targetDate).toInt()
    println("Birth date $birthDate, Target date $targetDate")
    println("Days between: $daysBetween")

    for (cycle in Cycle.values()) {
        val cycleLength = cycle.getLength()
        val positionInCycle = daysBetween % cycleLength
        val quadrantIndex = 4 * positionInCycle / cycleLength
        val percentage = (100 * sin(2 * Math.PI * positionInCycle / cycleLength)).roundToInt()

        val description = when {
            percentage > 95 -> "peak"
            percentage < -95 -> "valley"
            Math.abs(percentage) < 5 -> "critical transition"
            else -> {
                val daysToTransition = (cycleLength * (quadrantIndex + 1) / 4) - positionInCycle
                val transitionDate = targetDate.plusDays(daysToTransition.toLong())
                val (trend, nextTransition) = cycle.descriptions(quadrantIndex)
                "$percentage% ($trend, next $nextTransition $transitionDate)"
            }
        }

        println("${cycle.name} day $positionInCycle: $description")
    }
    println()
}

enum class Cycle(private val length: Int) {
    PHYSICAL(23), EMOTIONAL(28), MENTAL(33);

    fun getLength() = length

    fun descriptions(index: Int): Pair<String, String> {
        val descriptions = listOf(
            listOf("up and rising", "peak"),
            listOf("up but falling", "transition"),
            listOf("down and falling", "valley"),
            listOf("down but rising", "transition")
        )
        return descriptions[index][0] to descriptions[index][1]
    }
}
