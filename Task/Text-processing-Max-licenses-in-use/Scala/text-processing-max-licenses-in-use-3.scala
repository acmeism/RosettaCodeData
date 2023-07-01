import scala.annotation.tailrec

object License2 extends App {
  type resultTuple = (Int /*max*/, Int /*count*/, List[String] /*dates*/ )

  val src = io.Source.fromURL(
    "https://raw.githubusercontent.com/def-/nim-unsorted/master/mlijobs.txt")
  val iter = src.getLines()
  val (max, count, dates) = loop(Int.MinValue, 0, Nil)

  def lineToResult(tuple: (resultTuple, String)): resultTuple = {
    val ((max, count, dates), line) = tuple

    def date = line.split(" ")(3)

    if (line.startsWith("License OUT ")) {
      if (count + 1 > max) (count + 1, count + 1, List(date))
      else if (count + 1 == max) (max, max, dates :+ date)
      else (max, count + 1, dates)
    } else if (line.startsWith("License IN ")) tuple._1.copy(_2 = count - 1)
    else tuple._1
  }

  @tailrec
  private def loop(tuple: resultTuple): resultTuple = {
    def lineToResult(tuple: (resultTuple, String)): resultTuple = {
      val ((max, count, dates), line) = tuple

      def date = line.split(" ")(3)

      if (line.startsWith("License OUT ")) {
        if (count + 1 > max) (count + 1, count + 1, List(date))
        else if (count + 1 == max) (max, max, dates :+ date)
        else (max, count + 1, dates)
      } else if (line.startsWith("License IN ")) tuple._1.copy(_2 = count - 1)
      else tuple._1
    }

    if (iter.hasNext)
      loop(lineToResult(tuple, iter.next()))
    else tuple
  }

  println("Max licenses out: " + max)
  println("At time(s): " + dates.mkString(", "))

}
