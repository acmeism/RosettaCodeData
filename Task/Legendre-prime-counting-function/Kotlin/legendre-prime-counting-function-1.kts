fun countPrimes(lmt: Long): Long {
  if (lmt < 3) return if (lmt < 2) 0 else 1
  val sqrtlmt = Math.sqrt(lmt.toDouble()).toInt()
  fun makePrimes(): IntArray {
    val mxndx = (sqrtlmt - 3) / 2
    val arr = IntArray(mxndx + 1, { it + it + 3})
    var i = 0
    while (true) {
      val sqri = (i + i) * (i + 3) + 3
      if (sqri > mxndx) break
      if (arr[i] != 0) {
        val bp = i + i + 3
        for (c in sqri .. mxndx step bp) arr[c] = 0
      }
      i++
    }
    return arr.filter { it != 0 }.toIntArray()
  }
  val oprms = makePrimes()
  fun phi(x: Long, a: Int): Long {
    if (a <= 0) return x - (x shr 1)
    val na = a - 1; val p = oprms[na].toLong()
    if (x <= p) return 1
    return phi(x, na) - phi(x / p, na)
  }
  return phi(lmt, oprms.size) + oprms.size.toLong()
}

fun main() {
  val strt = System.currentTimeMillis()

  for (i in 0 .. 9) {
    val arg = Math.pow(10.toDouble(), i.toDouble()).toLong()
    println("π(10**$i) = ${countPrimes(arg)}")
  }

  val stop = System.currentTimeMillis()

  println("This took ${stop - strt} milliseconds.")
}
