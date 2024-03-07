/**
 * Using a simple formula derived from Hurwitz zeta function,
 * as described on https://en.wikipedia.org/wiki/Euler%27s_constant,
 * gives a result accurate to 11 decimal places: 0.57721566490...
 */

object EulerConstant extends App {

  println(gamma(1_000_000))

  private def gamma(N: Int): Double = {
    val sumOverN = (1 to N).map(1.0 / _).sum
    sumOverN - Math.log(N) - 1.0 / (2 * N)
  }

}
