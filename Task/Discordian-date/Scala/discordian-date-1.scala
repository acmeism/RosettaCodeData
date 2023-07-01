package rosetta

import java.util.GregorianCalendar
import java.util.Calendar

object DDate extends App {
  private val DISCORDIAN_SEASONS = Array("Chaos", "Discord", "Confusion", "Bureaucracy", "The Aftermath")

  // month from 1-12; day from 1-31
  def ddate(year: Int, month: Int, day: Int): String = {
    val date = new GregorianCalendar(year, month - 1, day)
    val dyear = year + 1166

    val isLeapYear = date.isLeapYear(year)
    if (isLeapYear && month == 2 && day == 29) // 2 means February
      "St. Tib's Day " + dyear + " YOLD"
    else {
      var dayOfYear = date.get(Calendar.DAY_OF_YEAR) - 1
      if (isLeapYear && dayOfYear >= 60)
        dayOfYear -= 1 // compensate for St. Tib's Day

      val dday = dayOfYear % 73
      val season = dayOfYear / 73
      "%s %d, %d YOLD".format(DISCORDIAN_SEASONS(season), dday + 1, dyear)
    }
  }
  if (args.length == 3)
    println(ddate(args(2).toInt, args(1).toInt, args(0).toInt))
  else if (args.length == 0) {
    val today = Calendar.getInstance
    println(ddate(today.get(Calendar.YEAR), today.get(Calendar.MONTH)+1, today.get(Calendar.DAY_OF_MONTH)))
  } else
    println("usage: DDate [day month year]")
}
