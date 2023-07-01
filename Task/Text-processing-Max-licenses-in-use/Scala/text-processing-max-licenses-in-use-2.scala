import scala.collection.mutable.ListBuffer

object License1 extends App {
  val src = io.Source.fromURL("https://raw.githubusercontent.com/def-/nim-unsorted/master/mlijobs.txt")

  val dates = new ListBuffer[String]
  var (max, count) = (Int.MinValue, 0)

  src.getLines.foreach { line =>
    def date = line.split(" ")(3)

    if (line.startsWith("License OUT ")) {
      count += 1
      if (count > max) {
        max = count
        dates.clear
      }
      if (count == max) dates += date
    } else if (line.startsWith("License IN ")) count -= 1
  }

  println("Max licenses out: " + max)
  println("At time(s): " + dates.mkString(", "))

}
