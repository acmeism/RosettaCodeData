import scala.annotation.tailrec

object CalculateE extends App {
  private val ε = 1.0e-15

  @tailrec
  def iter(fact: Long, ℯ: Double, n: Int, e0: Double): Double = {
    val newFact = fact * n
    val newE = ℯ + 1.0 / newFact
    if (math.abs(newE - ℯ) < ε) ℯ
    else iter(newFact, newE, n + 1, ℯ)
  }

  println(f"ℯ = ${iter(1L, 2.0, 2, 0)}%.15f")
}
