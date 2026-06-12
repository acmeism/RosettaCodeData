object CYKParser {

  // Non-terminal symbols
  val nonTerminals = List("NP", "Nom", "Det", "AP", "Adv", "A")
  val terminals = List("book", "orange", "man", "tall", "heavy", "very", "muscular")

  // Rules of the grammar
  val R: Map[String, List[List[String]]] = Map(
    "NP" -> List(List("Det", "Nom")),
    "Nom" -> List(List("AP", "Nom"), List("book"), List("orange"), List("man")),
    "AP" -> List(List("Adv", "A"), List("heavy"), List("orange"), List("tall")),
    "Det" -> List(List("a")),
    "Adv" -> List(List("very"), List("extremely")),
    "A" -> List(List("heavy"), List("orange"), List("tall"), List("muscular"))
  )

  // Function to perform the CYK Algorithm
  def cykParse(w: Array[String]): Unit = {
    val n = w.length

    // Initialize the table with empty sets
    val T = Array.ofDim[Set[String]](n, n)
    for (i <- 0 until n; j <- 0 until n) {
      T(i)(j) = Set.empty[String]
    }

    // Filling in the table
    for (j <- 0 until n) {

      // Iterate over the rules
      for ((lhs, rules) <- R) {
        for (rhs <- rules) {

          // If a terminal is found
          if (rhs.length == 1 && rhs(0) == w(j)) {
            T(j)(j) = T(j)(j) + lhs
          }
        }
      }

      for (i <- j to 0 by -1) {

        // Iterate over the range i to j
        for (k <- i until j) {

          // Iterate over the rules
          for ((lhs, rules) <- R) {
            for (rhs <- rules) {

              // If a non-terminal pair is found
              if (rhs.length == 2 &&
                  T(i)(k).contains(rhs(0)) &&
                  T(k + 1)(j).contains(rhs(1))) {
                T(i)(j) = T(i)(j) + lhs
              }
            }
          }
        }
      }
    }

    // If word can be formed by rules of given grammar
    if (T(0)(n - 1).contains("NP")) {
      println("True")
    } else {
      println("False")
    }
  }

  // Main method
  def main(args: Array[String]): Unit = {
    // Given string
    val w = "a very heavy orange book".split(" ")

    // Function Call
    cykParse(w)
  }
}
