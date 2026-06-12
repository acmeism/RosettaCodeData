import java.math.BigInteger
import scala.collection.mutable.ArrayBuffer

object RiordanNumbers extends App {a
  val limit = 10000
  val THREE = BigInteger.valueOf(3)

  val riordans: ArrayBuffer[BigInteger] = ArrayBuffer.fill(limit)(BigInteger.ZERO)
  riordans(0) = BigInteger.ONE
  riordans(1) = BigInteger.ZERO

  for (n <- 2 until limit) {
    val term = BigInteger.TWO.multiply(riordans(n - 1)).add(THREE.multiply(riordans(n - 2)))
    riordans(n) = BigInteger.valueOf(n - 1).multiply(term).divide(BigInteger.valueOf(n + 1))
  }

  println("The first 32 Riordan numbers:")
  for (i <- 0 until 32) {
    print(f"${riordans(i)}%14d")
    if (i % 4 == 3) println()
    else print(" ")
  }
  println()

  List(1000, 10000).foreach { count =>
    val length = riordans(count - 1).toString.length
    println(s"The ${count}th Riordan number has $length digits")
  }
}
