/**
 * This provides extra classes needed for the main
 * algorithm.
 */
trait Extras {

  import java.util.Calendar
  import java.util.GregorianCalendar
  import java.text.SimpleDateFormat
  import java.util.Locale

  import scala.collection.mutable.Buffer

  implicit class MyString(str: String) {
    def center(width: Int): String = {
      val leftSpaces = (width / 2) - (str.length() / 2)
      val rightSpaces = width - (leftSpaces + str.length)
      (" " * leftSpaces) + str + (" " * rightSpaces)
    }
  }

  case class MonthCalendar(monthInYear: Int, year: Int) {
    private val javaCalendar = makeJavaCalendar(year, monthInYear)
    private def makeJavaCalendar(year: Int, monthInYear: Int): Calendar = {
      val calendar = new GregorianCalendar()
      // Actually, other countries changed already in 1582,
      // which is the JDK's default implementation.
      val gregorianDateChangeInEngland = {
        val d = Calendar.getInstance()
        d.set(1752, Calendar.SEPTEMBER, 14)
        d.getTime()
      }
      // For England we need to set this explicitly.
      calendar.setGregorianChange(gregorianDateChangeInEngland)
      calendar.set(Calendar.DAY_OF_MONTH, 1)
      calendar.set(Calendar.YEAR, year)
      calendar.set(Calendar.MONTH, monthInYear - 1)
      calendar
    }
    val monthName = javaCalendar.getDisplayName(Calendar.MONTH, Calendar.LONG, Locale.ENGLISH)
    val dayOfWeek = javaCalendar.get(Calendar.DAY_OF_WEEK) - 1
    val daysInMonth = {
      val tempCal = makeJavaCalendar(year, monthInYear)
      val dayNumbers = Buffer[Int]()
      while (tempCal.get(Calendar.MONTH) == monthInYear - 1) {
        dayNumbers += tempCal.get(Calendar.DAY_OF_MONTH)
        tempCal.add(Calendar.DATE, 1)
      }
      dayNumbers
    }
  }

}
