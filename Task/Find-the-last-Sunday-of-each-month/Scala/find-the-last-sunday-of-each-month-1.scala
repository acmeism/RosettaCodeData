object FindTheLastSundayOfEachMonth extends App {
  import java.util.Calendar._
  val cal = getInstance

  def lastSundaysOf(year: Int) =
    (JANUARY to DECEMBER).map{month =>
      cal.set(year, month + 1, 1) // first day of next month
      (1 to 7).find{_ => cal.add(DAY_OF_MONTH, -1); cal.get(DAY_OF_WEEK) == SUNDAY}
      cal.getTime
    }

  val year = args.headOption.map(_.toInt).getOrElse(cal.get(YEAR))
  val fmt = new java.text.SimpleDateFormat("yyyy-MM-dd")
  println(lastSundaysOf(year).map(fmt.format) mkString "\n")
}
