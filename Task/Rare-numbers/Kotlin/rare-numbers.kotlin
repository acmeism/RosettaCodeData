import java.time.Duration
import java.time.LocalDateTime
import kotlin.math.sqrt

class Term(var coeff: Long, var ix1: Byte, var ix2: Byte)

const val maxDigits = 16

fun toLong(digits: List<Byte>, reverse: Boolean): Long {
    var sum: Long = 0
    if (reverse) {
        var i = digits.size - 1
        while (i >= 0) {
            sum = sum * 10 + digits[i]
            i--
        }
    } else {
        var i = 0
        while (i < digits.size) {
            sum = sum * 10 + digits[i]
            i++
        }
    }
    return sum
}

fun isSquare(n: Long): Boolean {
    val root = sqrt(n.toDouble()).toLong()
    return root * root == n
}

fun seq(from: Byte, to: Byte, step: Byte): List<Byte> {
    val res = mutableListOf<Byte>()
    var i = from
    while (i <= to) {
        res.add(i)
        i = (i + step).toByte()
    }
    return res
}

fun commatize(n: Long): String {
    var s = n.toString()
    val le = s.length
    var i = le - 3
    while (i >= 1) {
        s = s.slice(0 until i) + "," + s.substring(i)
        i -= 3
    }
    return s
}

fun main() {
    val startTime = LocalDateTime.now()
    var pow = 1L
    println("Aggregate timings to process all numbers up to:")
    // terms of (n-r) expression for number of digits from 2 to maxDigits
    val allTerms = mutableListOf<MutableList<Term>>()
    for (i in 0 until maxDigits - 1) {
        allTerms.add(mutableListOf())
    }
    for (r in 2..maxDigits) {
        val terms = mutableListOf<Term>()
        pow *= 10
        var pow1 = pow
        var pow2 = 1L
        var i1: Byte = 0
        var i2 = (r - 1).toByte()
        while (i1 < i2) {
            terms.add(Term(pow1 - pow2, i1, i2))

            pow1 /= 10
            pow2 *= 10

            i1++
            i2--
        }
        allTerms[r - 2] = terms
    }
    //  map of first minus last digits for 'n' to pairs giving this value
    val fml = mapOf(
        0.toByte() to listOf(listOf<Byte>(2, 2), listOf<Byte>(8, 8)),
        1.toByte() to listOf(listOf<Byte>(6, 5), listOf<Byte>(8, 7)),
        4.toByte() to listOf(listOf<Byte>(4, 0)),
        6.toByte() to listOf(listOf<Byte>(6, 0), listOf<Byte>(8, 2))
    )
    // map of other digit differences for 'n' to pairs giving this value
    val dmd = mutableMapOf<Byte, MutableList<List<Byte>>>()
    for (i in 0 until 100) {
        val a = listOf((i / 10).toByte(), (i % 10).toByte())
        val d = a[0] - a[1]
        dmd.getOrPut(d.toByte(), { mutableListOf() }).add(a)
    }
    val fl = listOf<Byte>(0, 1, 4, 6)
    val dl = seq(-9, 9, 1)  // all differences
    val zl = listOf<Byte>(0)                 // zero differences only
    val el = seq(-8, 8, 2)  // even differences only
    val ol = seq(-9, 9, 2)  // odd differences only
    val il = seq(0, 9, 1)
    val rares = mutableListOf<Long>()
    val lists = mutableListOf<MutableList<List<Byte>>>()
    for (i in 0 until 4) {
        lists.add(mutableListOf())
    }
    for (i_f in fl.withIndex()) {
        lists[i_f.index] = mutableListOf(listOf(i_f.value))
    }
    var digits = mutableListOf<Byte>()
    var count = 0

    // Recursive closure to generate (n+r) candidates from (n-r) candidates
    // and hence find Rare numbers with a given number of digits.
    fun fnpr(
        cand: List<Byte>,
        di: MutableList<Byte>,
        dis: List<List<Byte>>,
        indicies: List<List<Byte>>,
        nmr: Long,
        nd: Int,
        level: Int
    ) {
        if (level == dis.size) {
            digits[indicies[0][0].toInt()] = fml[cand[0]]?.get(di[0].toInt())?.get(0)!!
            digits[indicies[0][1].toInt()] = fml[cand[0]]?.get(di[0].toInt())?.get(1)!!
            var le = di.size
            if (nd % 2 == 1) {
                le--
                digits[nd / 2] = di[le]
            }
            for (i_d in di.slice(1 until le).withIndex()) {
                digits[indicies[i_d.index + 1][0].toInt()] = dmd[cand[i_d.index + 1]]?.get(i_d.value.toInt())?.get(0)!!
                digits[indicies[i_d.index + 1][1].toInt()] = dmd[cand[i_d.index + 1]]?.get(i_d.value.toInt())?.get(1)!!
            }
            val r = toLong(digits, true)
            val npr = nmr + 2 * r
            if (!isSquare(npr)) {
                return
            }
            count++
            print("     R/N %2d:".format(count))
            val checkPoint = LocalDateTime.now()
            val elapsed = Duration.between(startTime, checkPoint).toMillis()
            print("  %9sms".format(elapsed))
            val n = toLong(digits, false)
            println("  (${commatize(n)})")
            rares.add(n)
        } else {
            for (num in dis[level]) {
                di[level] = num
                fnpr(cand, di, dis, indicies, nmr, nd, level + 1)
            }
        }
    }

    // Recursive closure to generate (n-r) candidates with a given number of digits.
    fun fnmr(cand: MutableList<Byte>, list: List<List<Byte>>, indicies: List<List<Byte>>, nd: Int, level: Int) {
        if (level == list.size) {
            var nmr = 0L
            var nmr2 = 0L
            for (i_t in allTerms[nd - 2].withIndex()) {
                if (cand[i_t.index] >= 0) {
                    nmr += i_t.value.coeff * cand[i_t.index]
                } else {
                    nmr2 += i_t.value.coeff * -cand[i_t.index]
                    if (nmr >= nmr2) {
                        nmr -= nmr2
                        nmr2 = 0
                    } else {
                        nmr2 -= nmr
                        nmr = 0
                    }
                }
            }
            if (nmr2 >= nmr) {
                return
            }
            nmr -= nmr2
            if (!isSquare(nmr)) {
                return
            }
            val dis = mutableListOf<List<Byte>>()
            dis.add(seq(0, ((fml[cand[0]] ?: error("oops")).size - 1).toByte(), 1))
            for (i in 1 until cand.size) {
                dis.add(seq(0, (dmd[cand[i]]!!.size - 1).toByte(), 1))
            }
            if (nd % 2 == 1) {
                dis.add(il)
            }
            val di = mutableListOf<Byte>()
            for (i in 0 until dis.size) {
                di.add(0)
            }
            fnpr(cand, di, dis, indicies, nmr, nd, 0)
        } else {
            for (num in list[level]) {
                cand[level] = num
                fnmr(cand, list, indicies, nd, level + 1)
            }
        }
    }

    for (nd in 2..maxDigits) {
        digits = mutableListOf()
        for (i in 0 until nd) {
            digits.add(0)
        }
        if (nd == 4) {
            lists[0].add(zl)
            lists[1].add(ol)
            lists[2].add(el)
            lists[3].add(ol)
        } else if (allTerms[nd - 2].size > lists[0].size) {
            for (i in 0 until 4) {
                lists[i].add(dl)
            }
        }
        val indicies = mutableListOf<List<Byte>>()
        for (t in allTerms[nd - 2]) {
            indicies.add(listOf(t.ix1, t.ix2))
        }
        for (list in lists) {
            val cand = mutableListOf<Byte>()
            for (i in 0 until list.size) {
                cand.add(0)
            }
            fnmr(cand, list, indicies, nd, 0)
        }
        val checkPoint = LocalDateTime.now()
        val elapsed = Duration.between(startTime, checkPoint).toMillis()
        println("  %2d digits:  %9sms".format(nd, elapsed))
    }

    rares.sort()
    println("\nThe rare numbers with up to $maxDigits digits are:")
    for (i_rare in rares.withIndex()) {
        println("  %2d:  %25s".format(i_rare.index + 1, commatize(i_rare.value)))
    }
}
