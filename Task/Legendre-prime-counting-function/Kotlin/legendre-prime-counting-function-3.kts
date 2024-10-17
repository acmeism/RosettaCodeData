import java.util.BitSet

fun countPrimes(lmt: Long): Long {
  if (lmt < 3) return if (lmt < 2) 0 else 1 // odds only!
  fun half(x: Int): Int = (x - 1) shr 1
  fun divide(nm: Long, d: Long): Int = (nm.toDouble() / d.toDouble()).toInt()
  val sqrtlmt = Math.sqrt(lmt.toDouble()).toLong()
  val mxndx = ((sqrtlmt - 1) shr 1).toInt()
  val cmpsts = BitSet(mxndx + 1)
  val smalls = IntArray(mxndx + 1) { it }
  val roughs = IntArray(mxndx + 1) { it + it + 1 }
  val larges = LongArray(mxndx + 1) { (lmt / (it + it + 1).toLong() - 1) shr 1 }

  // partial sieve loop, adjusting larges/smalls, compressing larges/roughs...
  var nobps = 0; var rilmt = mxndx; var bp = 3.toLong()
  while (true) {
    val i = (bp shr 1).toInt(); val sqri = (i + i) * (i + 1)
    if (sqri > mxndx) break
    if (!cmpsts.get(i)) { // condition for partial sieving pass for bp is prime
      cmpsts.set(i) // cull bp!
      for (c in sqri .. mxndx step bp.toInt()) cmpsts.set(c) // cull bp mults!

      // now adjust `larges` for latest partial sieve pass...
      var ori = 0 // compress input rough index to output one
      for (iri in 0 .. rilmt) {
        val r = roughs[iri]; val rci = (r shr 1)
        if (cmpsts.get(rci)) continue // skip roughs culled in this sieve pass!
        val d = bp * r.toLong()
        larges[ori] = larges[iri] -
                        ( if (d <= sqrtlmt)
                            larges[smalls[(d shr 1).toInt()] - nobps]
                          else smalls[half(divide(lmt, d))].toLong() ) +
                          nobps.toLong() // base primes count over subtracted!
        roughs[ori++] = r
      }

      var si = mxndx // and adjust `smalls` for latest partial sieve pass...
      for (bpm in (sqrtlmt / bp - 1) or 1 downTo bp step 2) {
        val c = smalls[(bpm shr 1).toInt()] - nobps
        val ei = ((bpm * bp) shr 1).toInt()
        while (si >= ei) smalls[si--] -= c
      }

      nobps++; rilmt = ori - 1
    }
    bp += 2
  }

  // combine results to here; correcting for over subtraction in combining...
  var ans = larges[0]; for (i in 1 .. rilmt) ans -= larges[i]
  ans += (rilmt.toLong() + 1 + 2 * (nobps.toLong() - 1)) * rilmt.toLong() / 2

  // add final adjustment for pairs of current roughs to cube root of range...
  var ri = 0
  while (true) { // break when reaches cube root of counting range...
    val p = roughs[++ri].toLong(); val q = lmt / p
    val ei = smalls[half(divide(q, p))] - nobps
    if (ei <= ri) break // break here when no more pairs!
    for (ori in ri + 1 .. ei)
      ans += smalls[half(divide(q, roughs[ori].toLong()))].toLong()
    ans -= (ei - ri).toLong() * (nobps.toLong() + ri.toLong() - 1)
  }

  return ans + 1 // add one for only even prime of two!
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
