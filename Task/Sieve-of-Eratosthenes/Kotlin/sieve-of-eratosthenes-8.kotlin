internal typealias Prime = Long
internal typealias BasePrime = Int
internal typealias BasePrimeArray = IntArray
internal typealias SieveBuffer = ByteArray

// contains a lazy list of a secondary base prime arrays feed
internal data class BasePrimeArrays(val arr: BasePrimeArray,
                                     val rest: Lazy<BasePrimeArrays?>)
                                                : Sequence<BasePrimeArray> {
    override fun iterator() =
        generateSequence(this) { it.rest.value }
            .map { it.arr }.iterator()
}

// count the number of zero bits (primes) in a byte array,
fun countComposites(cmpsts: SieveBuffer): Int {
    var cnt = 0
    for (b in cmpsts) {
        cnt += java.lang.Integer.bitCount(b.toInt().and(0xFF))
    }
    return cmpsts.size.shl(3) - cnt
}

// converts an entire sieved array of bytes into an array of UInt32 primes,
// to be used as a source of base primes...
fun composites2BasePrimeArray(low: Int, cmpsts: SieveBuffer)
                                                            : BasePrimeArray {
    val lmti = cmpsts.size.shl(3)
    val len = countComposites(cmpsts)
    val rslt = BasePrimeArray(len)
    var j = 0
    for (i in 0 until lmti) {
        if (cmpsts[i.shr(3)].toInt() and 1.shl(i and 7) == 0) {
            rslt[j] = low + i + i; j++
        }
    }
    return rslt
}

// do sieving work based on low starting value for the given buffer and
// the given lazy list of base prime arrays...
fun sieveComposites(low: Prime, buffer: SieveBuffer,
                             bpas: Sequence<BasePrimeArray>) {
    val lowi = (low - 3L).shr(1)
    val len = buffer.size
    val lmti = len.shl(3)
    val nxti = lowi + lmti.toLong()
    for (bpa in bpas) {
        for (bp in bpa) {
            val bpi = (bp - 3).shr(1).toLong()
            var strti = (bpi * (bpi + 3L)).shl(1) + 3L
            if (strti >= nxti) return
            val s0 =
                if (strti >= lowi) (strti - lowi).toInt()
                else {
                    val r = (lowi - strti) % bp.toLong()
                    if (r.toInt() == 0) 0 else bp - r.toInt()
                }
            if (bp <= len.shr(3) && s0 <= lmti - bp.shl(6)) {
                val slmti = minOf(lmti, s0 + bp.shl(3))
                tailrec fun mods(s: Int) {
                    if (s < slmti) {
                        val msk = 1.shl(s and 7)
                        tailrec fun cull(c: Int) {
                            if (c < len) {
                                buffer[c] = (buffer[c].toInt() or msk).toByte()
                                cull(c + bp)
                            }
                        }
                        cull(s.shr(3)); mods(s + bp)
                    }
                }
                mods(s0)
            }
            else {
                tailrec fun cull(c: Int) {
                    if (c < lmti) {
                        val w = c.shr(3)
                        buffer[w] = (buffer[w].toInt() or 1.shl(c and 7)).toByte()
                        cull(c + bp)
                    }
                }
                cull(s0)
            }
        }
    }
}

// starts the secondary base primes feed with minimum size in bits set to 4K...
// thus, for the first buffer primes up to 8293,
// the seeded primes easily cover it as 97 squared is 9409...
fun makeBasePrimeArrays(): Sequence<BasePrimeArray> {
    var cmpsts = SieveBuffer(512)
    fun nextelem(low: Int, bpas: Sequence<BasePrimeArray>): BasePrimeArrays {
        // calculate size so that the bit span is at least as big as the
        // maximum culling prime required, rounded up to minsizebits blocks...
        val rqdsz = 2 + Math.sqrt((1 + low).toDouble()).toInt()
        val sz = (rqdsz.shr(12) + 1).shl(9) // size iin bytes
        if (sz > cmpsts.size) cmpsts = SieveBuffer(sz)
        cmpsts.fill(0)
        sieveComposites(low.toLong(), cmpsts, bpas)
        val arr = composites2BasePrimeArray(low, cmpsts)
        val nxt = low + cmpsts.size.shl(4)
        return BasePrimeArrays(arr, lazy { ->nextelem(nxt, bpas) })
    }
    // pre-seeding breaks recursive race,
    // as only known base primes used for first page...
    var preseedarr = intArrayOf( // pre-seed to 100, can sieve to 10,000...
        3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41
        , 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97 )
    return BasePrimeArrays(preseedarr, lazy {->nextelem(101, makeBasePrimeArrays())})
}

// a seqence over successive sieved buffer composite arrays,
// returning a tuple of the value represented by the lowest possible prime
// in the sieved composites array and the array itself;
// the array has a 16 Kilobytes minimum size (CPU L1 cache), but
// will grow so that the bit span is larger than the
// maximum culling base prime required, possibly making it larger than
// the L1 cache for large ranges, but still reasonably efficient using
// the L2 cache: very efficient up to about 16e9 range;
// reasonably efficient to about 2.56e14 for two Megabyte L2 cache = > 1 day...
fun makeSievePages(): Sequence<Pair<Prime,SieveBuffer>> {
    val bpas = makeBasePrimeArrays() // secondary source of base prime arrays
    fun init(): SieveBuffer {
        val c = SieveBuffer(16384); sieveComposites(3L, c, bpas); return c }
    return generateSequence(Pair(3L, init())) {
        (low, cmpsts) ->
            // calculate size so that the bit span is at least as big as the
            // max culling prime required, rounded up to minsizebits blocks...
            val rqdsz = 2 + Math.sqrt((1 + low).toDouble()).toInt()
            val sz = (rqdsz.shr(17) + 1).shl(14) // size iin bytes
            val ncmpsts = if (sz > cmpsts.size) SieveBuffer(sz) else cmpsts
            ncmpsts.fill(0)
            val nlow = low + ncmpsts.size.toLong().shl(4)
            sieveComposites(nlow, ncmpsts, bpas)
            Pair(nlow, ncmpsts)
    }
}

fun countPrimesTo(range: Prime): Prime {
    if (range < 3) { if (range < 2) return 0 else return 1 }
    var count = 1L
    for ((low,cmpsts) in makeSievePages()) {
        if (low + cmpsts.size.shl(4) > range) {
            val lsti = (range - low).shr(1).toInt()
            val lstw = lsti.shr(3)
            val msk = -2.shl(lsti.and(7))
            count += 32 + lstw.shl(3)
            for (i in 0 until lstw)
                count -= java.lang.Integer.bitCount(cmpsts[i].toInt().and(0xFF))
            count -= java.lang.Integer.bitCount(cmpsts[lstw].toInt().or(msk))
            break
        } else {
            count += countComposites(cmpsts)
        }
    }
    return count
}

// sequence over primes from above page iterator;
// unless doing something special with individual primes, usually unnecessary;
// better to do manipulations based on the composites bit arrays...
// takes at least as long to enumerate the primes as sieve them...
fun primesPaged(): Sequence<Prime> = sequence {
    yield(2L)
    for ((low,cmpsts) in makeSievePages()) {
        val szbts = cmpsts.size.shl(3)
        for (i in 0 until szbts) {
            if (cmpsts[i.shr(3)].toInt() and 1.shl(i and 7) != 0) continue
            yield(low + i.shl(1).toLong())
        }
    }
}
