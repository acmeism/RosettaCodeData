import org.apache.commons.math3.fraction.BigFraction

object Number2Fraction extends App {
  val n = Array(0.750000000, 0.518518000, 0.905405400,
    0.142857143, 3.141592654, 2.718281828, -0.423310825, 31.415926536)
  for (d <- n)
    println(f"$d%-12s : ${new BigFraction(d, 0.00000002D, 10000)}%s")
}
