object Doom extends App {
  val dates = Array(
    new Date(1800, 1, 6),
    new Date(1875, 3, 29),
    new Date(1915, 12, 7),
    new Date(1970, 12, 23),
    new Date(2043, 5, 14),
    new Date(2077, 2, 12),
    new Date(2101, 4, 2)
  )

  dates.foreach(d => println(s"${d.format}: ${d.weekday}"))
}

class Date(val year: Int, val month: Int, val day: Int) {
  import Date._

  def isLeapYear: Boolean = year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)

  def format: String = f"$month%02d/$day%02d/$year%04d"

  def weekday: String = {
    val c = year / 100
    val r = year % 100
    val s = r / 12
    val t = r % 12

    val cAnchor = (5 * (c % 4) + 2) % 7
    val doom = (s + t + t / 4 + cAnchor) % 7
    val anchor = if (isLeapYear) leapdoom(month - 1) else normdoom(month - 1)

    weekdays((doom + day - anchor + 7) % 7)
  }
}

object Date {
  private val leapdoom = Array(4, 1, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5)
  private val normdoom = Array(3, 7, 7, 4, 2, 6, 4, 1, 5, 3, 7, 5)
  val weekdays = Array("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday")
}
