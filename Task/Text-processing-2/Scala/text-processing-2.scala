object DataMunging2 {
  import scala.io.Source
  import scala.collection.immutable.{TreeMap => Map}

  val pattern = """^(\d+-\d+-\d+)""" + """\s+(\d+\.\d+)\s+(-?\d+)""" * 24 + "$" r;

  def main(args: Array[String]) {
    val files = args map (new java.io.File(_)) filter (file => file.isFile && file.canRead)
    val (numFormatErrors, numValidRecords, dateMap) =
      files.iterator.flatMap(file => Source fromFile file getLines ()).
        foldLeft((0, 0, new Map[String, Int] withDefaultValue 0)) {
        case ((nFE, nVR, dM), line) => pattern findFirstMatchIn line map (_.subgroups) match {
          case Some(List(date, rawData @ _*)) =>
            val allValid = (rawData map (_ toDouble) iterator) grouped 2 forall (_.last > 0)
            (nFE, nVR + (if (allValid) 1 else 0), dM(date) += 1)
          case None => (nFE + 1, nVR, dM)
        }
      }

    dateMap foreach {
      case (date, repetitions) if repetitions > 1 => println(date+": "+repetitions+" repetitions")
      case _ =>
    }

    println("""|
               |Valid records: %d
               |Duplicated dates: %d
               |Duplicated records: %d
               |Data format errors: %d
               |Invalid data records: %d
               |Total records: %d""".stripMargin format (
              numValidRecords,
              dateMap filter { case (_, repetitions) => repetitions > 1 } size,
              dateMap.valuesIterable filter (_ > 1) map (_ - 1) sum,
              numFormatErrors,
              dateMap.valuesIterable.sum - numValidRecords,
              dateMap.valuesIterable.sum))
  }
}
