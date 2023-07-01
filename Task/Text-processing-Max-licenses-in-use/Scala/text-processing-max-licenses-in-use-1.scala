import java.io.{BufferedReader, InputStreamReader}
import java.net.URL

object License0 extends App {
  val url = new URL("https://raw.githubusercontent.com/def-/nim-unsorted/master/mlijobs.txt")
  val in = new BufferedReader(new InputStreamReader(url.openStream()))

  val dates = new collection.mutable.ListBuffer[String]
  var (count: Int, max: Int) = (0, Int.MinValue)
  var line: String = _

  while ( {line = in.readLine; line} != null) {
    if (line.startsWith("License OUT ")) count += 1
    if (line.startsWith("License IN ")) count -= 1 // Redundant test when "OUT"
    if (count > max) { // Fruitless execution when "License IN "
      max = count
      val date = line.split(" ")(3)
      dates.clear()
      dates += date
    } else if (count == max) {
      val date = line.split(" ")(3)
      dates += date
    }
  }

  println("Max licenses out: " + max)
  println("At time(s): " + dates.mkString(", "))

}
