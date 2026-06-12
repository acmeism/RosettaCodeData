object DaysBetweenDates {

  /*Inspired by the Python version of the algorithm and the discussion here
   https://stackoverflow.com/questions/12862226/the-implementation-of-calculating-the-number-of-days-between-2-dates.*/

  /**Transform a date into a day number in the Gregorian Calendar*/
  def dateToDays(year : Int, month : Int, day : Int ) : Int = {
    val m = (month+ 9) % 12
    val y = year - m/10
    val d = day
    365*y + y/4 - y/100 + y/400 + (m*306 + 5)/10 + (d - 1)
  }

  /**Compute the difference of days between both input dates*/
  def daysDifference(firstDate : String, secondDate : String) : Int = {
    val firstDateTuple = firstDate.split('-') match { case Array(a, b, c) => (a, b, c) }
    val secondDateTuple = secondDate.split('-') match { case Array(a, b, c) => (a, b, c) }

    val firstYear = dateToDays( firstDateTuple._1.toInt, firstDateTuple._2.toInt, firstDateTuple._3.toInt)
    val secondYear = dateToDays( secondDateTuple._1.toInt, secondDateTuple._2.toInt, secondDateTuple._3.toInt )

    return secondYear - firstYear
  }

  def main(args: Array[String]): Unit = {
    println(daysDifference("2019-01-01", "2019-09-30"))
    println(daysDifference("1995-11-21", "1995-11-21"))
    println(daysDifference("2019-01-01", "2019-01-02"))
    println(daysDifference("2019-01-02", "2019-01-01"))
    println(daysDifference("2019-01-01", "2019-03-01"))
    println(daysDifference("2020-01-01", "2020-03-01"))
    println(daysDifference("1902-01-01", "1968-12-25"))
    println(daysDifference("2090-01-01", "2098-12-25"))
    println(daysDifference("1902-01-01", "2098-12-25"))
  }

}
