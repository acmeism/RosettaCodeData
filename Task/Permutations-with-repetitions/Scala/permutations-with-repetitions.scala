package permutationsRep

object PermutationsRepTest extends Application {
  /**
   * Calculates all permutations taking n elements of the input List,
   * with repetitions.
   * Precondition: input.length > 0 && n > 0
   */
  def permutationsWithRepetitions[T](input : List[T], n : Int) : List[List[T]] = {
    require(input.length > 0 && n > 0)
    n match {
      case 1 => for (el <- input) yield List(el)
      case _ => for (el <- input; perm <- permutationsWithRepetitions(input, n - 1)) yield el :: perm
    }
  }
  println(permutationsWithRepetitions(List(1, 2, 3), 2))
}
