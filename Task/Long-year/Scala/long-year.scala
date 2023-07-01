import java.time.temporal.TemporalAdjusters.firstInMonth
import java.time.temporal.{ChronoField, IsoFields}
import java.time.{DayOfWeek, LocalDate, Month}

import scala.util.{Failure, Try}

private object LongYear extends App {
  private val (currentCentury, maxWeekNumber) = (LocalDate.now().getYear / 100, ChronoField.ALIGNED_WEEK_OF_YEAR.range().getMaximum)
  private val centuries = currentCentury * 100 until (currentCentury + 1) * 100
  private val results = List(
    centuries.filter(isThursdayFirstOrLast),
    centuries.filter(year => maxIsoWeeks(year) == maxWeekNumber),
    centuries.filter(mostThursdaysInYear)
  )

  // Solution 1, the first or respectively last day of the year is a Thursday.
  private def isThursdayFirstOrLast(_year: Int): Boolean = {

    LocalDate.of(_year, Month.DECEMBER, 31).get(ChronoField.DAY_OF_WEEK) == DayOfWeek.THURSDAY.getValue ||
    LocalDate.of(_year, Month.JANUARY, 1).get(ChronoField.DAY_OF_WEEK) == DayOfWeek.THURSDAY.getValue
  }

  // Solution 2, if last week that contains at least four days of the month of December.
  private def maxIsoWeeks(_year: Int) = {
    // The last week that contains at least four days of the month of December.
    LocalDate.of(_year, Month.DECEMBER, 28).get(IsoFields.WEEK_OF_WEEK_BASED_YEAR)
  }

  // Solution 3, if there are 52 Thursdays in a year
  private def mostThursdaysInYear(_year: Int) = {
    val datum = LocalDate.of(_year, Month.JANUARY, 1).`with`(firstInMonth(DayOfWeek.THURSDAY))

    datum.plusDays(52 * 7).getYear == _year
  }

  println(s"Years in this ${currentCentury + 1}st century having ISO week $maxWeekNumber :")

  Try { // Testing the solutions
    assert(results.tail.forall(_ == results.head), "Discrepancies in results.")
  } match {
    case Failure(ex) => Console.err.println(ex.getMessage)
    case _ =>
  }

  results.zipWithIndex.foreach(solution => println(s"Solution ${solution._2}: ${solution._1.mkString(" ")}"))

}
