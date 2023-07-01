// version 1.2.10

import java.math.BigInteger
import java.math.BigDecimal
import java.math.MathContext

val bigZero = BigInteger.ZERO
val bigOne  = BigInteger.ONE
val bdZero  = BigDecimal.ZERO
val context = MathContext.UNLIMITED

fun gcd(a: BigInteger, b: BigInteger): BigInteger
    = if (b == bigZero) a else gcd(b, a % b)

class Frac : Comparable<Frac> {
    val num: BigInteger
    val denom: BigInteger

    constructor(n: BigInteger, d: BigInteger) {
        require(d != bigZero)
        var nn = n
        var dd = d
        if (nn == bigZero) {
            dd = bigOne
        }
        else if (dd < bigZero) {
            nn = -nn
            dd = -dd
        }
        val g = gcd(nn, dd).abs()
        if (g > bigOne) {
            nn /= g
            dd /= g
        }
        num = nn
        denom = dd
    }

    constructor(n: Int, d: Int) : this(n.toBigInteger(), d.toBigInteger())

    operator fun plus(other: Frac) =
        Frac(num * other.denom + denom * other.num, other.denom * denom)

    operator fun unaryMinus() = Frac(-num, denom)

    operator fun minus(other: Frac) = this + (-other)

    override fun compareTo(other: Frac): Int {
        val diff = this.toBigDecimal() - other.toBigDecimal()
        return when {
            diff < bdZero  -> -1
            diff > bdZero  -> +1
            else           ->  0
        }
    }

    override fun equals(other: Any?): Boolean {
       if (other == null || other !is Frac) return false
       return this.compareTo(other) == 0
    }

    override fun toString() = if (denom == bigOne) "$num" else "$num/$denom"

    fun toBigDecimal() = num.toBigDecimal() / denom.toBigDecimal()

    fun toEgyptian(): List<Frac> {
        if (num == bigZero) return listOf(this)
        val fracs = mutableListOf<Frac>()
        if (num.abs() >= denom.abs()) {
            val div = Frac(num / denom, bigOne)
            val rem = this - div
            fracs.add(div)
            toEgyptian(rem.num, rem.denom, fracs)
        }
        else {
            toEgyptian(num, denom, fracs)
        }
        return fracs
    }

    private tailrec fun toEgyptian(
        n: BigInteger,
        d: BigInteger,
        fracs: MutableList<Frac>
    ) {
        if (n == bigZero) return
        val n2 = n.toBigDecimal()
        val d2 = d.toBigDecimal()
        var divRem = d2.divideAndRemainder(n2, context)
        var div = divRem[0].toBigInteger()
        if (divRem[1] > bdZero) div++
        fracs.add(Frac(bigOne, div))
        var n3 = (-d) % n
        if (n3 < bigZero) n3 += n
        val d3 = d * div
        val f = Frac(n3, d3)
        if (f.num == bigOne) {
            fracs.add(f)
            return
        }
        toEgyptian(f.num, f.denom, fracs)
    }
}

fun main(args: Array<String>) {
    val fracs = listOf(Frac(43, 48), Frac(5, 121), Frac(2014,59))
    for (frac in fracs) {
        val list = frac.toEgyptian()
        if (list[0].denom == bigOne) {
            val first = "[${list[0]}]"
            println("$frac -> $first + ${list.drop(1).joinToString(" + ")}")
        }
        else {
            println("$frac -> ${list.joinToString(" + ")}")
        }
    }

    for (r in listOf(98, 998)) {
        if (r == 98)
            println("\nFor proper fractions with 1 or 2 digits:")
        else
            println("\nFor proper fractions with 1, 2 or 3 digits:")
        var maxSize = 0
        var maxSizeFracs = mutableListOf<Frac>()
        var maxDen = bigZero
        var maxDenFracs = mutableListOf<Frac>()
        val sieve = List(r + 1) { BooleanArray(r + 2) }  // to eliminate duplicates
        for (i in 1..r) {
            for (j in (i + 1)..(r + 1)) {
                if (sieve[i][j]) continue
                val f = Frac(i, j)
                val list = f.toEgyptian()
                val listSize = list.size
                if (listSize > maxSize) {
                    maxSize = listSize
                    maxSizeFracs.clear()
                    maxSizeFracs.add(f)
                }
                else if (listSize == maxSize) {
                    maxSizeFracs.add(f)
                }
                val listDen = list[list.lastIndex].denom
                if (listDen > maxDen) {
                    maxDen = listDen
                    maxDenFracs.clear()
                    maxDenFracs.add(f)
                }
                else if (listDen == maxDen) {
                    maxDenFracs.add(f)
                }
                if (i < r / 2) {
                   var k = 2
                   while (true) {
                       if (j * k > r + 1) break
                       sieve[i * k][j * k] = true
                       k++
                   }
                }
            }
        }
        println("  largest number of items = $maxSize")
        println("  fraction(s) with this number : $maxSizeFracs")
        val md = maxDen.toString()
        print("  largest denominator = ${md.length} digits, ")
        println("${md.take(20)}...${md.takeLast(20)}")
        println("  fraction(s) with this denominator : $maxDenFracs")
    }
}
