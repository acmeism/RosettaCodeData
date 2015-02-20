object LastLetterFirstLetterLookup extends App {
  def solve(names: Set[String]) = {
    val transitions = {
      val startsWith = names.groupBy(_.take(1).toLowerCase).withDefaultValue(Set.empty)
      names.map{name => name -> startsWith(name.takeRight(1).toLowerCase)}.toMap
    }

    def extend(solutions: List[List[String]]): List[List[String]] =
      solutions.flatMap{solution =>
        (transitions(solution.head) -- solution).map(_ :: solution)
      } match {
        case Nil => solutions
        case more => extend(more)
      }

    extend(names.toList.map(List(_))).map(_.reverse)
  }

  val names70 = Set("audino", "bagon", "baltoy", "banette", "bidoof", "braviary", "bronzor", "carracosta", "charmeleon", "cresselia", "croagunk", "darmanitan", "deino", "emboar", "emolga", "exeggcute", "gabite", "girafarig", "gulpin", "haxorus", "heatmor", "heatran", "ivysaur", "jellicent", "jumpluff", "kangaskhan", "kricketune", "landorus", "ledyba", "loudred", "lumineon", "lunatone", "machamp", "magnezone", "mamoswine", "nosepass", "petilil", "pidgeotto", "pikachu", "pinsir", "poliwrath", "poochyena", "porygon2", "porygonz", "registeel", "relicanth", "remoraid", "rufflet", "sableye", "scolipede", "scrafty", "seaking", "sealeo", "silcoon", "simisear", "snivy", "snorlax", "spoink", "starly", "tirtouga", "trapinch", "treecko", "tyrogue", "vigoroth", "vulpix", "wailord", "wartortle", "whismur", "wingull", "yamask")

  val solutions = solve(names70)
  println(s"Maximum path length: ${solutions.head.length}")
  println(s"Paths of that length: ${solutions.size}")
  println("Example path of that length:")
  println(solutions.head.sliding(7,7).map(_.mkString(" ")).map("  "+_).mkString("\n"))
}
