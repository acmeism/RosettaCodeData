import scala.collection.parallel.immutable.ParSeq

object LeftTruncatablePrime extends App {
  private def leftTruncatablePrime(maxRadix: Int, millerRabinCertainty: Int) {
    def getLargestLeftTruncatablePrime(radix: Int, millerRabinCertainty: Int): BigInt = {
      def getNextLeftTruncatablePrimes(n: BigInt, radix: Int, millerRabinCertainty: Int) = {
        def baseString = if (n == 0) "" else n.toString(radix)

        for {i <- (1 until radix).par
             p = BigInt(Integer.toString(i, radix) + baseString, radix)
             if p.isProbablePrime(millerRabinCertainty)
        } yield p
      }

      def iter(list: ParSeq[BigInt], lastList: ParSeq[BigInt]): ParSeq[BigInt] = {
        if (list.isEmpty) lastList
        else
          iter((for (n <- list.par) yield getNextLeftTruncatablePrimes(n, radix, millerRabinCertainty)).flatten, list)
      }

      iter(getNextLeftTruncatablePrimes(0, radix, millerRabinCertainty), ParSeq.empty).max
    }

    for (radix <- (3 to maxRadix).par) {
      val largest = getLargestLeftTruncatablePrime(radix, millerRabinCertainty)
      println(f"n=$radix%3d: " +
        (if (largest == null) "No left-truncatable prime"
        else f"$largest%35d (in base $radix%3d) ${largest.toString(radix)}"))

    }
  }

  val argu: Array[String] = if (args.length >=2 ) args.slice(0, 2) else Array("17", "100")
  val maxRadix = argu(0).toInt.ensuring(_ > 2, "Radix must be an integer greater than 2.")

  try {
    val millerRabinCertainty = argu(1).toInt

    println(s"Run with maxRadix = $maxRadix and millerRabinCertainty = $millerRabinCertainty")

    leftTruncatablePrime(maxRadix, millerRabinCertainty)
    println(s"Successfully completed without errors. [total ${scala.compat.Platform.currentTime - executionStart} ms]")
  }
  catch {
    case _: NumberFormatException => Console.err.println("Miller-Rabin Certainty must be an integer.")
  }

}
