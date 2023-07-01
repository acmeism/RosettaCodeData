import scala.io.Source

object MarkovAlgorithm {
  val RulePattern = """(.*?)\s+->\s+(\.?)(.*)""".r
  val CommentPattern = """#.*|\s*""".r

  def rule(line: String) = line match {
    case CommentPattern() => None
    case RulePattern(pattern, terminal, replacement) => Some(pattern, replacement, terminal == ".")
    case _ => error("Syntax error on line "+line)
  }

  def main(args: Array[String]) {
    if (args.size != 2 ) {
      println("Syntax: MarkovAlgorithm inputFile inputPattern")
      exit(1)
    }

    val rules = (Source fromPath args(0) getLines () map rule).toList.flatten

    def algorithm(input: String): String = rules find (input contains _._1) match {
      case Some((pattern, replacement, true)) => input replaceFirst ("\\Q"+pattern+"\\E", replacement)
      case Some((pattern, replacement, false)) => algorithm(input replaceFirst ("\\Q"+pattern+"\\E", replacement))
      case None => input
    }

    println(args(1))
    println(algorithm(args(1)))
  }
}
