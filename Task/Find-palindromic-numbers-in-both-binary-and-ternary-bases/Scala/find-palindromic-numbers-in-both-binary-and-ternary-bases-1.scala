import scala.annotation.tailrec
import scala.compat.Platform.currentTime

object Palindrome23 extends App {
  private val executionStartTime = currentTime
  private val st: Stream[(Int, Long)] = (0, 1L) #:: st.map(xs => nextPalin3(xs._1))

  @tailrec
  private def nextPalin3(n: Int): (Int, Long) = {

    @inline
    def isPali2(i: BigInt): Boolean = {
      val s = i.toString(2)
      if ((s.length & 1) == 0) false else s == s.reverse
    }

    def palin3(i: BigInt): Long = {
      val n3 = i.toString(3)
      java.lang.Long.parseLong(n3 + "1" + n3.reverse, 3)
    }

    val actual: Long = palin3(n)
    if (isPali2(actual)) (n + 1, actual) else nextPalin3(n + 1)
  }

  println(f"${"Decimal"}%18s${"Binary"}%35s${"Ternary"}%51s")
  (Stream(0L) ++ st.map(_._2)).take(6).foreach(n => {
    val bigN = BigInt(n)
    val (bin, ter) = (bigN.toString(2), bigN.toString(3))

    println(f"${n}%18d, ${
      bin + " " * ((60 - bin.length) / 2)}%60s, ${
      ter + " " * ((37 - ter.length) / 2)}%37s")
  })

  println(s"Successfully completed without errors. [total ${currentTime - executionStartTime} ms]")

}
