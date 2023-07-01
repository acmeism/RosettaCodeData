object SuperpermutationMinimisation extends App {
  val nMax = 12

  @annotation.tailrec
  def factorial(number: Int, acc: Long = 1): Long =
    if (number == 0) acc else factorial(number - 1, acc * number)

  def factSum(n: Int): Long = (1 to n).map(factorial(_)).sum

  for (n <- 0 until nMax) println(f"superPerm($n%2d) len = ${factSum(n)}%d")

}
