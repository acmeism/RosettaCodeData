object Binomial extends App {
  def binomialCoefficient(n: Int, k: Int) =
    (BigInt(n - k + 1) to n).product /
    (BigInt(1) to k).product

  val Array(n, k) = args.map(_.toInt)
  println("The Binomial Coefficient of %d and %d equals %,3d.".format(n, k, binomialCoefficient(n, k)))
}
