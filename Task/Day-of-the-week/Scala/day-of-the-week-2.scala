import java.time.{ DayOfWeek, LocalDate }

object DayOfTheWeek1 extends App {
  val years = 2008 to 2121
  val yuletide = for {
    year <- years
    if LocalDate.of(year, 12, 25).getDayOfWeek() == DayOfWeek.SUNDAY
  } yield year

  println(yuletide.mkString(
    s"${yuletide.count(p => true)} Years between ${years.head} and ${years.last}" +
      " including where Christmas is observed on Sunday:\n", ", ", "."))
}
