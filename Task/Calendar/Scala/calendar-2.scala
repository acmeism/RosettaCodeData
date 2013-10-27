/**
 * Loosely based on the Ruby implementation.
 *
 * Focuses on immutability and Scala idioms,
 * while trying to remain readable and clean.
 */
object YearCalendarApp extends App with Extras {

  val defaultYear = 1752
  val columns = 86

  val year = args.headOption.map(_.toInt).getOrElse(defaultYear)

  yearCalendarLines(year, columns).foreach(println)

  def yearCalendarLines(year: Int, columns: Int): Seq[String] = {
    // At least one. Divide rest columns by width + 2 spaces (separator)
    val calendarsPerRow = 1 + (columns - 20) / (20 + 2)

    // Use 20 columns per month + 2 spaces between months
    val width = calendarsPerRow * 22 - 2

    List(
      "[Snoopy]".center(width),
      s"${year}".center(width)) ++
      // Get, group, transpose and join calendar lines
      allMonthCalendarLines(year).grouped(calendarsPerRow).flatMap { calGroup =>
        calGroup.transpose.map(stringsInRow => stringsInRow.mkString("  "))
      }
  }

  def allMonthCalendarLines(year: Int): Seq[Seq[String]] = {
    (1 to 12).map { monthNr =>
      val date = MonthCalendar(monthInYear = monthNr, year)

      // Make array of 42 days (7 * 6 weeks max.) starting with Sunday (which is 0)
      val daySlotsInMonth = {
        (Seq().padTo(date.dayOfWeek, "  ") ++
          date.daysInMonth.map { dayNr => "%2d".format(dayNr) }).
          padTo(42, "  ")
      }

      List(
        date.monthName.center(20),
        "Su Mo Tu We Th Fr Sa") ++
        daySlotsInMonth.grouped(7).map { weekSlots => weekSlots.mkString(" ") }
    }
  }

}
