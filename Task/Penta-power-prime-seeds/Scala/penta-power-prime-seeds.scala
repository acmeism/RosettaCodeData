import scala.annotation.tailrec
import java.math.BigInteger

object PentaPowerPrimeSeeds extends App {
  println("The first 30 penta-power prime seeds:")
  val first30 = Stream.from(1, 2).filter(isPentaPowerPrimeSeed).take(30)
  first30.zipWithIndex.foreach { case (seed, index) =>
    print(f"$seed%7d${if ((index + 1) % 6 == 0) "\n" else " "}")
  }

  val firstAbove10M = Stream.from(1, 2).filter(isPentaPowerPrimeSeed).find(_ > 10000000)
  firstAbove10M match {
    case Some(seed) => println(s"\nThe first penta-power prime seed greater than 10,000,000 is $seed")
    case None => println("No penta-power prime seed greater than 10,000,000 was found.")
  }

  def isPentaPowerPrimeSeed(number: Int): Boolean = {
    val bigIntNumber = BigInteger.valueOf(number)
    val bigIntNumberPlusOne = bigIntNumber.add(BigInteger.ONE)
    (0 to 4).forall { i =>
      bigIntNumber.pow(i).add(bigIntNumberPlusOne).isProbablePrime(15)
    }
  }
}
