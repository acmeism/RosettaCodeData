val cTinyPhiPrimes = intArrayOf(2, 3, 5, 7, 11, 13)
val cTinyPhiDeg = cTinyPhiPrimes.size - 1
val cTinyPhiOddCirc = cTinyPhiPrimes.reduce(Int::times) / 2
val cTinyPhiTot = cTinyPhiPrimes.fold(1) { s, p -> s * (p - 1) }
fun makeTPLUT(): IntArray {
  val arr = IntArray(cTinyPhiOddCirc) { _ -> 1 }
  for (bp in cTinyPhiPrimes.drop(1)) {
    arr[bp shr 1] = 0
    for (c in ((bp * bp) shr 1) until cTinyPhiOddCirc step bp) arr[c] = 0 }
  var acc = 0
  for (i in 0 until cTinyPhiOddCirc) { acc += arr[i]; arr[i] = acc }
  return arr
}
val cTinyPhiLUT = makeTPLUT()
fun tinyPhi(x: Long): Long {
  val ndx = (x - 1) shr 1; val numtots = ndx / cTinyPhiOddCirc.toLong()
  val rem = (ndx - numtots * cTinyPhiOddCirc.toLong()).toInt()
  return numtots * cTinyPhiTot.toLong() + cTinyPhiLUT[rem].toLong()
}

fun countPrimes(lmt: Long): Long {
  if (lmt < 169) {
    if (lmt < 3) return if (lmt < 2) 0 else 1
    // adjust for the missing "degree" base primes
    if (lmt <= 13)
      return ((lmt - 1).toLong() shr 1) + (if (lmt < 9) 1 else 0);
    return 5.toLong() + cTinyPhiLUT[(lmt - 1).toInt() shr 1].toLong();
  }
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
  fun lvl(pilmt: Int, m: Long): Long {
    var acc = 0.toLong()
    for (pi in cTinyPhiDeg until pilmt) {
      val p = oprms[pi].toLong(); val nm = m * p
      if (lmt <= nm * p) return acc + (pilmt - pi).toLong()
      val q = (lmt.toDouble() / nm.toDouble()).toLong(); acc += tinyPhi(q)
      if (pi > cTinyPhiDeg) acc -= lvl(pi, nm)
    }
    return acc
  }
  return tinyPhi(lmt) - lvl(oprms.size, 1) + oprms.size.toLong()
}
