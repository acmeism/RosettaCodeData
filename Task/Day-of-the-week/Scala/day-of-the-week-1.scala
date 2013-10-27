import java.util.{ Calendar, GregorianCalendar }
import Calendar.{ DAY_OF_WEEK, DECEMBER, SUNDAY }

object DayOfTheWeek extends App {
  val years = 2008 to 2121
  val yuletide = for {
    year <- years
    if (new GregorianCalendar(year, DECEMBER, 25)).get(DAY_OF_WEEK) == SUNDAY
  } yield year

  println(yuletide.mkString(
    s"${yuletide.count(p => true)} Years between ${years.head} and ${years.last}" +
      " including where Christmas is observed on Sunday:\n", ", ", "."))
}
