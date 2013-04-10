import java.util.{Calendar, GregorianCalendar}
import Calendar._

object DayOfTheWeek {

  def main(args:Array[String]) {
    for (year <- 2008 to 2121;
         date <- Some(new GregorianCalendar(year, DECEMBER, 25));
         if date.get(DAY_OF_WEEK) == SUNDAY) {
      println(year)
    }
  }
}
