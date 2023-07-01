def decode(s: String, Code: scala.util.matching.Regex = """(\d+)?([a-zA-Z])""".r) =
  Code.findAllIn(s).foldLeft("") { case (acc, Code(len, c)) =>
    acc + c * Option(len).map(_.toInt).getOrElse(1)
  }
