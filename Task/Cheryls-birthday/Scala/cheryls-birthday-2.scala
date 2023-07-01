object Cheryl_sBirthday extends App {

  private val possiblerDates = Set(
    Date("May", 15), Date("May", 16), Date("May", 19),
    Date("June", 17), Date("June", 18),
    Date("July", 14), Date("July", 16),
    Date("August", 14), Date("August", 15), Date("August", 17)
  )

  private def clou3: Date = {
    // Find the dates with ONE unique once and only occurrence of the day of the month.
    def onceDates[K](toBeExcluded: Set[Date], selector: Date => K): Seq[Date] =
      toBeExcluded.groupBy(selector).filter { case (_, multiSet) => multiSet.size == 1 }.values.flatten.toSeq

    // 1) Albert tells us that Bernard doesn't know the answer,
    // so we know the answer must be in months that does NOT have a same day of month.
    val uniqueMonths = onceDates(possiblerDates, (date: Date) => date.dayOfMonth).map(_.month)
    // Remove the dates with those months. The dates remain which has NOT those months.
    val clou1 = possiblerDates.filterNot(p => uniqueMonths.contains(p.month))
    // 2) Since Bernard now knows the answer, that tells us that the day MUST be unique among the remaining birthdays.
    val uniqueDays = onceDates(clou1, (date: Date) => date.dayOfMonth).map(_.dayOfMonth)

    // 3) Since Albert now knows the answer, that tells us the answer has to be unique by month.
    // First, as the first parameter, intersect clou1 (Albert) with uniqueDays (Bernard)
    onceDates(clou1.filter(date => uniqueDays.contains(date.dayOfMonth)), (date: Date) => date.month).head
  }

  case class Date(month: String, dayOfMonth: Int) {
    override def toString: String = s"${"🎂 " * 3}$dayOfMonth $month${" 🎂" * 3}"
  }

  println(clou3)
}
