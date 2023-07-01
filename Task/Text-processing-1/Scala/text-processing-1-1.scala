object DataMunging {
  import scala.io.Source

  def spans[A](list: List[A]) = list.tail.foldLeft(List((list.head, 1))) {
    case ((a, n) :: tail, b) if a == b => (a, n + 1) :: tail
    case (l, b) => (b, 1) :: l
  }

  type Flag = ((Boolean, Int), String)
  type Flags = List[Flag]
  type LineIterator = Iterator[Option[(Double, Int, Flags)]]

  val pattern = """^(\d+-\d+-\d+)""" + """\s+(\d+\.\d+)\s+(-?\d+)""" * 24 + "$" r;

  def linesIterator(file: java.io.File) = Source.fromFile(file).getLines().map(
    pattern findFirstMatchIn _ map (
      _.subgroups match {
        case List(date, rawData @ _*) =>
          val dataset = (rawData map (_ toDouble) iterator) grouped 2 toList;
          val valid = dataset filter (_.last > 0) map (_.head)
          val validSize = valid length;
          val validSum = valid sum;
          val flags = spans(dataset map (_.last > 0)) map ((_, date))
          println("Line: %11s  Reject: %2d  Accept: %2d  Line_tot: %10.3f  Line_avg: %10.3f" format
                  (date, 24 - validSize, validSize, validSum, validSum / validSize))
          (validSum, validSize, flags)
      }
    )
  )

  def totalizeLines(fileIterator: LineIterator) =
    fileIterator.foldLeft(0.0, 0, List[Flag]()) {
      case ((totalSum, totalSize, ((flag, size), date) :: tail), Some((validSum, validSize, flags))) =>
        val ((firstFlag, firstSize), _) = flags.last
        if (firstFlag == flag) {
          (totalSum + validSum, totalSize + validSize, flags.init ::: ((flag, size + firstSize), date) :: tail)
        } else {
          (totalSum + validSum, totalSize + validSize, flags ::: ((flag, size), date) :: tail)
        }
      case ((_, _, Nil), Some(partials)) => partials
      case (totals, None) => totals
    }

  def main(args: Array[String]) {
    val files = args map (new java.io.File(_)) filter (file => file.isFile && file.canRead)
    val lines =  files.iterator flatMap linesIterator
    val (totalSum, totalSize, flags) = totalizeLines(lines)
    val ((_, invalidCount), startDate) = flags.filter(!_._1._1).max
    val report = """|
                    |File(s)  = %s
                    |Total    = %10.3f
                    |Readings = %6d
                    |Average  = %10.3f
                    |
                    |Maximum run(s) of %d consecutive false readings began at %s""".stripMargin
    println(report format (files mkString " ", totalSum, totalSize, totalSum / totalSize, invalidCount, startDate))
  }
}
