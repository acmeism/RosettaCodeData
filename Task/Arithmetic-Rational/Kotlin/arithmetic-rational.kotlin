// version 1.1.2

fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

infix fun Long.ldiv(denom: Long) = Frac(this, denom)

infix fun Int.idiv(denom: Int) = Frac(this.toLong(), denom.toLong())

fun Long.toFrac() = Frac(this, 1)

fun Int.toFrac() = Frac(this.toLong(), 1)

class Frac : Comparable<Frac> {
    val num: Long
    val denom: Long

    companion object {
        val ZERO = Frac(0, 1)
        val ONE  = Frac(1, 1)
    }

    constructor(n: Long, d: Long) {
        require(d != 0L)
        var nn = n
        var dd = d
        if (nn == 0L) {
            dd = 1
        }
        else if (dd < 0) {
            nn = -nn
            dd = -dd
        }
        val g = Math.abs(gcd(nn, dd))
        if (g > 1) {
            nn /= g
            dd /= g
        }
        num = nn
        denom = dd
    }

    constructor(n: Int, d: Int) : this(n.toLong(), d.toLong())

    operator fun plus(other: Frac) =
        Frac(num * other.denom + denom * other.num, other.denom * denom)

    operator fun unaryPlus() = this

    operator fun unaryMinus() = Frac(-num, denom)

    operator fun minus(other: Frac) = this + (-other)

    operator fun times(other: Frac) = Frac(this.num * other.num, this.denom * other.denom)

    operator fun rem(other: Frac) = this - Frac((this / other).toLong(), 1) * other

    operator fun inc() = this + ONE
    operator fun dec() = this - ONE

    fun inverse(): Frac {
        require(num != 0L)
        return Frac(denom, num)
    }

    operator fun div(other: Frac) = this * other.inverse()

    fun abs() = if (num >= 0) this else -this

    override fun compareTo(other: Frac): Int {
        val diff = this.toDouble() - other.toDouble()
        return when {
            diff < 0.0  -> -1
            diff > 0.0  -> +1
            else        ->  0
        }
    }

    override fun equals(other: Any?): Boolean {
       if (other == null || other !is Frac) return false
       return this.compareTo(other) == 0
    }

    override fun hashCode() = num.hashCode() xor denom.hashCode()

    override fun toString() = if (denom == 1L) "$num" else "$num/$denom"

    fun toDouble() = num.toDouble() / denom

    fun toLong() = num / denom
}

fun isPerfect(n: Long): Boolean {
    var sum = Frac(1, n)
    val limit = Math.sqrt(n.toDouble()).toLong()
    for (i in 2L..limit) {
        if (n % i == 0L) sum += Frac(1, i) + Frac(1, n / i)
    }
    return sum == Frac.ONE
}

fun main(args: Array<String>) {
    var frac1 = Frac(12, 3)
    println ("frac1 = $frac1")
    var frac2 = 15 idiv 2
    println("frac2 = $frac2")
    println("frac1 <= frac2 is ${frac1 <= frac2}")
    println("frac1 >= frac2 is ${frac1 >= frac2}")
    println("frac1 == frac2 is ${frac1 == frac2}")
    println("frac1 != frac2 is ${frac1 != frac2}")
    println("frac1 + frac2 = ${frac1 + frac2}")
    println("frac1 - frac2 = ${frac1 - frac2}")
    println("frac1 * frac2 = ${frac1 * frac2}")
    println("frac1 / frac2 = ${frac1 / frac2}")
    println("frac1 % frac2 = ${frac1 % frac2}")
    println("inv(frac1)    = ${frac1.inverse()}")
    println("abs(-frac1)   = ${-frac1.abs()}")
    println("inc(frac2)    = ${++frac2}")
    println("dec(frac2)    = ${--frac2}")
    println("dbl(frac2)    = ${frac2.toDouble()}")
    println("lng(frac2)    = ${frac2.toLong()}")
    println("\nThe Perfect numbers less than 2^19 are:")
    // We can skip odd numbers as no known perfect numbers are odd
    for (i in 2 until (1 shl 19) step 2) {
        if (isPerfect(i.toLong())) print("  $i")
    }
    println()
}
