import scala.math.BigInt

object PrimalityByWilsonsTheorem extends App {
  println("Primes less than 100 testing by Wilson's Theorem")
  (0 to 100).foreach(i => if (isPrime(i)) print(s"$i "))

  private def isPrime(p: Long): Boolean = {
    if (p <= 1) return false
    (fact(p - 1).+(BigInt(1))).mod(BigInt(p)) == BigInt(0)
  }

  private def fact(n: Long): BigInt = {
    (2 to n.toInt).foldLeft(BigInt(1))((fact, i) => fact * BigInt(i))
  }
}
