object LexicographicalNumbers extends App {  def ints = List(0, 5, 13, 21, -22)

  def lexOrder(n: Int): Seq[Int] = (if (n < 1) n to 1 else 1 to n).sortBy(_.toString)

  println("In lexicographical order:\n")
  for (n <- ints) println(f"$n%3d: ${lexOrder(n).mkString("[",", ", "]")}%s")

}
