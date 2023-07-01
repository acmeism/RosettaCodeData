import java.math.BigInteger
import java.time.Duration
import java.util.ArrayList
import java.util.HashSet
import kotlin.math.sqrt

const val ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz|"
var base: Byte = 0
var bmo: Byte = 0
var blim: Byte = 0
var ic: Byte = 0
var st0: Long = 0
var bllim: BigInteger? = null
var threshold: BigInteger? = null
var hs: MutableSet<Byte> = HashSet()
var o: MutableSet<Byte> = HashSet()
val chars = ALPHABET.toCharArray()
var limits: MutableList<BigInteger?>? = null
var ms: String? = null

fun indexOf(c: Char): Int {
    for (i in chars.indices) {
        if (chars[i] == c) {
            return i
        }
    }
    return -1
}

// convert BigInteger to string using current base
fun toStr(b: BigInteger): String {
    var b2 = b
    val bigBase = BigInteger.valueOf(base.toLong())
    val res = StringBuilder()
    while (b2 > BigInteger.ZERO) {
        val divRem = b2.divideAndRemainder(bigBase)
        res.append(chars[divRem[1].toInt()])
        b2 = divRem[0]
    }
    return res.toString()
}

// check for a portion of digits, bailing if uneven
fun allInQS(b: BigInteger): Boolean {
    var b2 = b
    val bigBase = BigInteger.valueOf(base.toLong())
    var c = ic.toInt()
    hs.clear()
    hs.addAll(o)
    while (b2 > bllim) {
        val divRem = b2.divideAndRemainder(bigBase)
        hs.add(divRem[1].toByte())
        c++
        if (c > hs.size) {
            return false
        }
        b2 = divRem[0]
    }
    return true
}

// check for a portion of digits, all the way to the end
fun allInS(b: BigInteger): Boolean {
    var b2 = b
    val bigBase = BigInteger.valueOf(base.toLong())
    hs.clear()
    hs.addAll(o)
    while (b2 > bllim) {
        val divRem = b2.divideAndRemainder(bigBase)
        hs.add(divRem[1].toByte())
        b2 = divRem[0]
    }
    return hs.size == base.toInt()
}

// check for all digits, bailing if uneven
fun allInQ(b: BigInteger): Boolean {
    var b2 = b
    val bigBase = BigInteger.valueOf(base.toLong())
    var c = 0
    hs.clear()
    while (b2 > BigInteger.ZERO) {
        val divRem = b2.divideAndRemainder(bigBase)
        hs.add(divRem[1].toByte())
        c++
        if (c > hs.size) {
            return false
        }
        b2 = divRem[0]
    }
    return true
}

// check for all digits, all the way to the end
fun allIn(b: BigInteger): Boolean {
    var b2 = b
    val bigBase = BigInteger.valueOf(base.toLong())
    hs.clear()
    while (b2 > BigInteger.ZERO) {
        val divRem = b2.divideAndRemainder(bigBase)
        hs.add(divRem[1].toByte())
        b2 = divRem[0]
    }
    return hs.size == base.toInt()
}

// parse a string into a BigInteger, using current base
fun to10(s: String?): BigInteger {
    val bigBase = BigInteger.valueOf(base.toLong())
    var res = BigInteger.ZERO
    for (element in s!!) {
        val idx = indexOf(element)
        val bigIdx = BigInteger.valueOf(idx.toLong())
        res = res.multiply(bigBase).add(bigIdx)
    }
    return res
}

// returns the minimum value string, optionally inserting extra digit
fun fixup(n: Int): String {
    var res = ALPHABET.substring(0, base.toInt())
    if (n > 0) {
        val sb = StringBuilder(res)
        sb.insert(n, n)
        res = sb.toString()
    }
    return "10" + res.substring(2)
}

// checks the square against the threshold, advances various limits when needed
fun check(sq: BigInteger) {
    if (sq > threshold) {
        o.remove(indexOf(ms!![blim.toInt()]).toByte())
        blim--
        ic--
        threshold = limits!![bmo - blim - 1]
        bllim = to10(ms!!.substring(0, blim + 1))
    }
}

// performs all the calculations for the current base
fun doOne() {
    limits = ArrayList()
    bmo = (base - 1).toByte()
    var dr: Byte = 0
    if ((base.toInt() and 1) == 1) {
        dr = (base.toInt() shr 1).toByte()
    }
    o.clear()
    blim = 0
    var id: Byte = 0
    var inc = 1
    val st = System.nanoTime()
    val sdr = ByteArray(bmo.toInt())
    var rc: Byte = 0
    for (i in 0 until bmo) {
        sdr[i] = (i * i % bmo).toByte()
        if (sdr[i] == dr) {
            rc = (rc + 1).toByte()
        }
        if (sdr[i] == 0.toByte()) {
            sdr[i] = (sdr[i] + bmo).toByte()
        }
    }
    var i: Long = 0
    if (dr > 0) {
        id = base
        i = 1
        while (i <= dr) {
            if (sdr[i.toInt()] >= dr) {
                if (id > sdr[i.toInt()]) {
                    id = sdr[i.toInt()]
                }
            }
            i++
        }
        id = (id - dr).toByte()
        i = 0
    }
    ms = fixup(id.toInt())
    var sq = to10(ms)
    var rt = BigInteger.valueOf((sqrt(sq.toDouble()) + 1).toLong())
    sq = rt.multiply(rt)
    if (base > 9) {
        for (j in 1 until base) {
            limits!!.add(to10(ms!!.substring(0, j) + chars[bmo.toInt()].toString().repeat(base - j + if (rc > 0) 0 else 1)))
        }
        limits!!.reverse()
        while (sq < limits!![0]) {
            rt = rt.add(BigInteger.ONE)
            sq = rt.multiply(rt)
        }
    }
    var dn = rt.shiftLeft(1).add(BigInteger.ONE)
    var d = BigInteger.ONE
    if (base > 3 && rc > 0) {
        while (sq.remainder(BigInteger.valueOf(bmo.toLong())).compareTo(BigInteger.valueOf(dr.toLong())) != 0) {
            rt = rt.add(BigInteger.ONE)
            sq = sq.add(dn)
            dn = dn.add(BigInteger.TWO)
        } // aligns sq to dr
        inc = bmo / rc
        if (inc > 1) {
            dn = dn.add(rt.multiply(BigInteger.valueOf(inc - 2.toLong())).subtract(BigInteger.ONE))
            d = BigInteger.valueOf(inc * inc.toLong())
        }
        dn = dn.add(dn).add(d)
    }
    d = d.shiftLeft(1)
    if (base > 9) {
        blim = 0
        while (sq < limits!![bmo - blim - 1]) {
            blim++
        }
        ic = (blim + 1).toByte()
        threshold = limits!![bmo - blim - 1]
        if (blim > 0) {
            for (j in 0..blim) {
                o.add(indexOf(ms!![j]).toByte())
            }
        }
        bllim = if (blim > 0) {
            to10(ms!!.substring(0, blim + 1))
        } else {
            BigInteger.ZERO
        }
        if (base > 5 && rc > 0) while (!allInQS(sq)) {
            sq = sq.add(dn)
            dn = dn.add(d)
            i += 1
            check(sq)
        } else {
            while (!allInS(sq)) {
                sq = sq.add(dn)
                dn = dn.add(d)
                i += 1
                check(sq)
            }
        }
    } else {
        if (base > 5 && rc > 0) {
            while (!allInQ(sq)) {
                sq = sq.add(dn)
                dn = dn.add(d)
                i += 1
            }
        } else {
            while (!allIn(sq)) {
                sq = sq.add(dn)
                dn = dn.add(d)
                i += 1
            }
        }
    }
    rt = rt.add(BigInteger.valueOf(i * inc))
    val delta1 = System.nanoTime() - st
    val dur1 = Duration.ofNanos(delta1)
    val delta2 = System.nanoTime() - st0
    val dur2 = Duration.ofNanos(delta2)
    System.out.printf(
        "%3d  %2d  %2s %20s -> %-40s %10d %9s  %9s\n",
        base, inc, if (id > 0) ALPHABET.substring(id.toInt(), id + 1) else " ", toStr(rt), toStr(sq), i, format(dur1), format(dur2)
    )
}

private fun format(d: Duration): String {
    val minP = d.toMinutesPart()
    val secP = d.toSecondsPart()
    val milP = d.toMillisPart()
    return String.format("%02d:%02d.%03d", minP, secP, milP)
}

fun main() {
    println("base inc id                 root    square                                   test count    time        total")
    st0 = System.nanoTime()
    base = 2
    while (base < 28) {
        doOne()
        ++base
    }
}
