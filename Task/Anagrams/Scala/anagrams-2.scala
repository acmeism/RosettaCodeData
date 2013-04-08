Source
  .fromURL("http://www.puzzlers.org/pub/wordlists/unixdict.txt").getLines.toList
  .groupBy(_.sorted).values
  .groupBy(_.size).maxBy(_._1)._2
  .map(_.mkString("\t"))
  .foreach(println)
