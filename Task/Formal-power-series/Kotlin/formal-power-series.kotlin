// version 1.2.10

fun gcd(a: Long, b: Long): Long = if (b == 0L) a else gcd(b, a % b)

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

    operator fun times(other: Frac) =
        Frac(this.num * other.num, this.denom * other.denom)

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

interface Gene {
    fun coef(n: Int): Frac
}

class Term(private val gene: Gene) {
    private val cache = mutableListOf<Frac>()

    operator fun get(n: Int): Frac {
        if (n < 0) return Frac.ZERO
        if (n >= cache.size) {
            for (i in cache.size..n) cache.add(gene.coef(i))
        }
        return cache[n]
    }
}

class FormalPS {
    private lateinit var term: Term

    private companion object {
        const val DISP_TERM = 12
        const val X_VAR = "x"
    }

    constructor() {}

    constructor(term: Term) {
        this.term = term
    }

    constructor(polynomial: List<Frac>) :
        this(Term(object : Gene {
            override fun coef(n: Int) =
                if (n < 0 || n >= polynomial.size)
                    Frac.ZERO
                else
                    polynomial[n]
        }))

    fun copyFrom(other: FormalPS) {
        term = other.term
    }

    fun inverseCoef(n: Int): Frac {
        val res = Array(n + 1) { Frac.ZERO }
        res[0] = term[0].inverse()
        for (i in 1..n) {
            for (j in 0 until i) res[i] += term[i - j] * res[j]
            res[i] *= -res[0]
        }
        return res[n]
    }

    operator fun plus(other: FormalPS) =
        FormalPS(Term(object : Gene {
            override fun coef(n: Int) = term[n] + other.term[n]
        }))

    operator fun minus(other: FormalPS) =
        FormalPS(Term(object : Gene {
            override fun coef(n: Int) = term[n] - other.term[n]
        }))

    operator fun times(other: FormalPS) =
        FormalPS(Term(object : Gene {
            override fun coef(n: Int): Frac {
                var res = Frac.ZERO
                for (i in 0..n) res += term[i] * other.term[n - i]
                return res
            }
        }))

    operator fun div(other: FormalPS) =
        FormalPS(Term(object : Gene {
            override fun coef(n: Int): Frac {
                var res = Frac.ZERO
                for (i in 0..n) res += term[i] * other.inverseCoef(n - i)
                return res
            }
        }))

    fun diff() =
        FormalPS(Term(object : Gene {
            override fun coef(n: Int) = term[n + 1] * Frac(n + 1, 1)
        }))

    fun intg() =
        FormalPS(Term(object : Gene {
            override fun coef(n: Int) =
                if (n == 0) Frac.ZERO else term[n - 1] * Frac(1, n)
        }))

    override fun toString() = toString(DISP_TERM)

    private fun toString(dpTerm: Int): String {
        val sb = StringBuilder()
        var c = term[0]
        if (c != Frac.ZERO) sb.append(c.toString())
        for (i in 1 until dpTerm) {
            c = term[i]
            if (c != Frac.ZERO) {
                if (c > Frac.ZERO && sb.length > 0) sb.append(" + ")
                sb.append (when {
                    c == Frac.ONE  -> X_VAR
                    c == -Frac.ONE -> " - $X_VAR"
                    c.num < 0      -> " - ${-c}$X_VAR"
                    else           -> "$c$X_VAR"
                })
                if (i > 1) sb.append("^$i")
            }
        }
        if (sb.length == 0) sb.append("0")
        sb.append(" + ...")
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    var cos = FormalPS()
    val sin = cos.intg()
    cos.copyFrom(FormalPS(listOf(Frac.ONE)) - sin.intg())
    println("SIN(x) = $sin")
    println("COS(x) = $cos")
}
