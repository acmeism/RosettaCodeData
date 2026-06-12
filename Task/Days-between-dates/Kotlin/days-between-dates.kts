import java.time.LocalDate
import java.time.temporal.ChronoUnit

fun main() {
    val fromDate = LocalDate.parse("2019-01-01")
    val toDate = LocalDate.parse("2019-10-19")
    val diff = ChronoUnit.DAYS.between(fromDate, toDate)
    println("Number of days between $fromDate and $toDate: $diff")
}
