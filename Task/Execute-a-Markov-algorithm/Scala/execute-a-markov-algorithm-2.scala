import scala.io.Source

if (argv.size != 2 ) error("Syntax: MarkovAlgorithm inputFile inputPattern")

val rulePattern = """(.*?)\s+->\s+(\.?)(.*)""".r
val isComment = (_: String) matches "#.*|\\s*"
val rules = Source fromPath args(0) getLines () filterNot isComment map (rulePattern unapplySeq _ get) toList;

def algorithm(input: String): String = rules find (input contains _.head) match {
  case Some(Seq(pattern, ".", replacement)) => input replaceFirst ("\\Q"+pattern+"\\E", replacement)
  case Some(Seq(pattern, "", replacement)) => algorithm(input replaceFirst ("\\Q"+pattern+"\\E", replacement))
  case None => input
}

println(argv(1))
println(algorithm(argv(1)))
