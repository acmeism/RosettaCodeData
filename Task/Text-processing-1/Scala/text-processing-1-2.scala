object AltDataMunging {
  def main(args: Array[String]) {
    var totalSum = 0.0
    var totalSize  = 0
    var maxInvalidDate = ""
    var maxInvalidCount = 0
    var invalidDate = ""
    var invalidCount = 0
    val files = args map (new java.io.File(_)) filter (file => file.isFile && file.canRead)

    files.iterator flatMap (file => Source fromFile file getLines ()) map (_.trim split "\\s+") foreach {
      case Array(date, rawData @ _*) =>
        val dataset = (rawData map (_ toDouble) iterator) grouped 2 toList;
        val valid = dataset filter (_.last > 0) map (_.head)
        val flags = spans(dataset map (_.last > 0)) map ((_, date))
        println("Line: %11s  Reject: %2d  Accept: %2d  Line_tot: %10.3f  Line_avg: %10.3f" format
                (date, 24 - valid.size, valid.size, valid.sum, valid.sum / valid.size))
        totalSum += valid.sum
        totalSize += valid.size
        dataset foreach {
          case _ :: flag :: Nil if flag > 0 =>
            if (invalidCount > maxInvalidCount) {
              maxInvalidDate = invalidDate
              maxInvalidCount = invalidCount
            }
            invalidCount = 0
          case _ =>
            if (invalidCount == 0) invalidDate = date
            invalidCount += 1
        }
    }

    val report = """|
                    |File(s)  = %s
                    |Total    = %10.3f
                    |Readings = %6d
                    |Average  = %10.3f
                    |
                    |Maximum run(s) of %d consecutive false readings began at %s""".stripMargin
    println(report format (files mkString " ", totalSum, totalSize, totalSum / totalSize, maxInvalidCount, maxInvalidDate))
  }
}
