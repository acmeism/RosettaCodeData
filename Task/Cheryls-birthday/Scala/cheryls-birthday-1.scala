import java.time.format.DateTimeFormatter
import java.time.{LocalDate, Month}

object Cheryl {
  def main(args: Array[String]): Unit = {
    val choices = List(
      LocalDate.of(2019, Month.MAY, 15),
      LocalDate.of(2019, Month.MAY, 16),
      LocalDate.of(2019, Month.MAY, 19),

      LocalDate.of(2019, Month.JUNE, 17),
      LocalDate.of(2019, Month.JUNE, 18),

      LocalDate.of(2019, Month.JULY, 14),
      LocalDate.of(2019, Month.JULY, 16),

      LocalDate.of(2019, Month.AUGUST, 14),
      LocalDate.of(2019, Month.AUGUST, 15),
      LocalDate.of(2019, Month.AUGUST, 17)
    )

    // The month cannot have a unique day because Albert knows the month, and knows that Bernard does not know the answer
    val uniqueMonths = choices.groupBy(_.getDayOfMonth)
      .filter(a => a._2.length == 1)
      .flatMap(a => a._2)
      .map(a => a.getMonth)
    val filter1 = choices.filterNot(a => uniqueMonths.exists(b => a.getMonth == b))

    // Bernard now knows the answer, so the day must be unique within the remaining choices
    val uniqueDays = filter1.groupBy(_.getDayOfMonth)
      .filter(a => a._2.length == 1)
      .flatMap(a => a._2)
      .map(a => a.getDayOfMonth)
    val filter2 = filter1.filter(a => uniqueDays.exists(b => a.getDayOfMonth == b))

    // Albert knows the answer too, so the month must be unique within the remaining choices
    val birthDay = filter2.groupBy(_.getMonth)
      .filter(a => a._2.length == 1)
      .flatMap(a => a._2)
      .head

    // print the result
    printf(birthDay.format(DateTimeFormatter.ofPattern("MMMM dd")))
  }
}
