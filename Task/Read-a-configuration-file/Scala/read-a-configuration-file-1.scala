val conf = scala.io.Source.fromFile("config.file").
  getLines.
  toList.
  filter(_.trim.size > 0).
  filterNot("#;" contains _(0)).
  map(_ split(" ", 2) toList).
  map(_ :+ "true" take 2).
  map {
    s:List[String] => (s(0).toLowerCase, s(1).split(",").map(_.trim).toList)
  }.toMap
