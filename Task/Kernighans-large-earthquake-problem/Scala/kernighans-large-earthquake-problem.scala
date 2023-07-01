scala.io.Source.fromFile("data.txt").getLines
  .map("\\s+".r.split(_))
  .filter(_(2).toDouble > 6.0)
  .map(_.mkString("\t"))
  .foreach(println)
