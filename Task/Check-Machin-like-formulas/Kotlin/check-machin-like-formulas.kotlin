// version 1.1.3

import java.math.BigInteger

val bigZero = BigInteger.ZERO
val bigOne = BigInteger.ONE

class BigRational : Comparable<BigRational> {

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
        val g = nn.gcd(dd)
        if (g > bigOne) {
            nn /= g
            dd /= g
        }
        num = nn
        denom = dd
    }

    constructor(n: Long, d: Long) : this(BigInteger.valueOf(n), BigInteger.valueOf(d))

    operator fun plus(other: BigRational) =
        BigRational(num * other.denom + denom * other.num, other.denom * denom)

    operator fun unaryMinus() = BigRational(-num, denom)

    operator fun minus(other: BigRational) = this + (-other)

    operator fun times(other: BigRational) = BigRational(this.num * other.num, this.denom * other.denom)

    fun inverse(): BigRational {
        require(num != bigZero)
        return BigRational(denom, num)
    }

    operator fun div(other: BigRational) = this * other.inverse()

    override fun compareTo(other: BigRational): Int {
        val diff = this - other
        return when {
            diff.num < bigZero -> -1
            diff.num > bigZero -> +1
            else               ->  0
        }
    }

    override fun equals(other: Any?): Boolean {
       if (other == null || other !is BigRational) return false
       return this.compareTo(other) == 0
    }

    override fun toString() = if (denom == bigOne) "$num" else "$num/$denom"

    companion object {
        val ZERO = BigRational(bigZero, bigOne)
        val ONE  = BigRational(bigOne, bigOne)
    }
}

/** represents a term of the form: c * atan(n / d) */
class Term(val c: Long, val n: Long, val d: Long) {

    override fun toString() = when {
        c ==  1L   -> " + "
        c == -1L   -> " - "
        c <   0L   -> " - ${-c}*"
        else       -> " + $c*"
    } + "atan($n/$d)"
}

val one = BigRational.ONE

fun tanSum(terms: List<Term>): BigRational {
    if (terms.size == 1) return tanEval(terms[0].c, BigRational(terms[0].n, terms[0].d))
    val half = terms.size / 2
    val a = tanSum(terms.take(half))
    val b = tanSum(terms.drop(half))
    return (a + b) / (one - (a * b))
}

fun tanEval(c: Long, f: BigRational): BigRational {
    if (c == 1L)  return f
    if (c < 0L) return -tanEval(-c, f)
    val ca = c / 2
    val cb = c - ca
    val a = tanEval(ca, f)
    val b = tanEval(cb, f)
    return (a + b) / (one - (a * b))
}

fun main(args: Array<String>) {
    val termsList = listOf(
        listOf(Term(1, 1, 2), Term(1, 1, 3)),
        listOf(Term(2, 1, 3), Term(1, 1, 7)),
        listOf(Term(4, 1, 5), Term(-1, 1, 239)),
        listOf(Term(5, 1, 7), Term(2, 3, 79)),
        listOf(Term(5, 29, 278), Term(7, 3, 79)),
        listOf(Term(1, 1, 2), Term(1, 1, 5), Term(1, 1, 8)),
        listOf(Term(4, 1, 5), Term(-1, 1, 70), Term(1, 1, 99)),
        listOf(Term(5, 1, 7), Term(4, 1, 53), Term(2, 1, 4443)),
        listOf(Term(6, 1, 8), Term(2, 1, 57), Term(1, 1, 239)),
        listOf(Term(8, 1, 10), Term(-1, 1, 239), Term(-4, 1, 515)),
        listOf(Term(12, 1, 18), Term(8, 1, 57), Term(-5, 1, 239)),
        listOf(Term(16, 1, 21), Term(3, 1, 239), Term(4, 3, 1042)),
        listOf(Term(22, 1, 28), Term(2, 1, 443), Term(-5, 1, 1393), Term(-10, 1, 11018)),
        listOf(Term(22, 1, 38), Term(17, 7, 601), Term(10, 7, 8149)),
        listOf(Term(44, 1, 57), Term(7, 1, 239), Term(-12, 1, 682), Term(24, 1, 12943)),
        listOf(Term(88, 1, 172), Term(51, 1, 239), Term(32, 1, 682), Term(44, 1, 5357), Term(68, 1, 12943)),
        listOf(Term(88, 1, 172), Term(51, 1, 239), Term(32, 1, 682), Term(44, 1, 5357), Term(68, 1, 12944))
    )

    for (terms in termsList) {
        val f = String.format("%-5s << 1 == tan(", tanSum(terms) == one)
        print(f)
        print(terms[0].toString().drop(3))
        for (i in 1 until terms.size) print(terms[i])
        println(")")
    }
}
