object AbbreviationsAuto extends App {
  private val wd = os.pwd

  def processLine(line: String): String = {
    if (line.nonEmpty) {
      val days = line.split(' ')
      val maxL = days.map(_.length).max
      val paddedNames = days.map(s => s.padTo(maxL, ' '))

      def uniqueN = (1 to maxL) // distinct filters uniques
        .map(n => paddedNames.map(_.substring(0, n)).distinct)
        .filter(_.size == paddedNames.length)  // `.distinct` filters uniques
        .head.head.length

      f"$uniqueN%3d $line" // Return by means of String Interpolation
    } else "    \"\""
  }

  os.read.lines(wd / "days_of_week.txt")
    .distinct
    .foreach(line => println(processLine(line)))

}
