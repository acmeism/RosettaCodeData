import scala.math.BigInt

object MillerRabinPrimalityTest extends App {
  val (n, certainty )= (BigInt(args(0)), args(1).toInt)
  println(s"$n is ${if (n.isProbablePrime(certainty)) "probably prime" else "composite"}")
}
