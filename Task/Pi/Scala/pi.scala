object Pi {
  class PiIterator extends Iterable[BigInt] {
    var r: BigInt = 0
    var q, t, k: BigInt = 1
    var n, l: BigInt = 3

    def iterator: Iterator[BigInt] = new Iterator[BigInt] {
      def hasNext = true

      def next(): BigInt = {
        while ((4 * q + r - t) >= (n * t)) {
          val nr = (2 * q + r) * l
          val nn = (q * (7 * k) + 2 + (r * l)) / (t * l)
          q = q * k
          t = t * l
          l = l + 2
          k = k + 1
          n = nn
          r = nr
        }
        val ret = n
        val nr = 10 * (r - n * t)
        n = ((10 * (3 * q + r)) / t) - (10 * n)
        q = q * 10
        r = nr
        ret
      }
    }
  }

  def main(args: Array[String]): Unit = {
    val it = new PiIterator
    println("" + (it.head) + "." + (it.take(300).mkString))
  }

}
