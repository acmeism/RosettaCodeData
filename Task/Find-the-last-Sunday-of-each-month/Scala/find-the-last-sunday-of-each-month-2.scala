object FindTheLastSundayOfEachMonth extends App {
  def lastSundaysOf(year: Int) = (1 to 12).map{month =>
    import java.time._; import java.time.temporal.TemporalAdjusters._
    LocalDate.of(year, month, 1).`with`(lastDayOfMonth).`with`(previousOrSame(DayOfWeek.SUNDAY))}

  val year = args.headOption.map(_.toInt).getOrElse(java.time.LocalDate.now.getYear)
  println(lastSundaysOf(year) mkString "\n")
}
