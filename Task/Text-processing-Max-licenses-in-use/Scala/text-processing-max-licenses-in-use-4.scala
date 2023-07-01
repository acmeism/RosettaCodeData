object License3 extends App {
  type resultTuple = (Int /*max*/, Int /*count*/, List[String] /*dates*/ )

  val src = io.Source.fromURL("https://raw.githubusercontent.com/def-/nim-unsorted/master/mlijobs.txt")

  val (max, count, dates): resultTuple =
    src.getLines().foldLeft(Int.MinValue, 0, Nil: List[String]) {
      case ((max: Int, count: Int, dates: List[String]), line: String)
        if line.startsWith("License OUT ") =>
        def date = line.split(" ")(3)

        if (count + 1 > max) (count + 1, count + 1, List(date))
        else if (count + 1 == max) (max, max, dates :+ date)
        else (max, count + 1, dates)

      case (resultPart: resultTuple, line: String)
        if line.startsWith("License IN ") =>
        resultPart.copy(_2 = resultPart._2 - 1)

      case (resultPart, _) => resultPart
    }

  println("Max licenses out: " + max)
  println("At time(s): " + dates.mkString(", "))

}
