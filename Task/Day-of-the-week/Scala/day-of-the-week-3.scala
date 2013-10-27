import java.time.{ DayOfWeek, LocalDate }

object DayOfTheWeek2 extends App {
  val years = 2008 to 2121
  val yuletide =
    years.filter(yr => LocalDate.of(yr, 12, 25).getDayOfWeek() == DayOfWeek.SUNDAY)

  println(yuletide.mkString(
    s"${yuletide.count(p => true)} Years between ${years.head} and ${years.last}" +
      " including where Christmas is observed on Sunday:\n", ", ", "."))
}
