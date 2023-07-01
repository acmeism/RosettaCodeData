import java.util.TreeMap
import kotlin.math.abs
import kotlin.math.pow
import kotlin.math.sqrt

private const val algorithm = 2

fun main() {
    println("Task 1:  cyclotomic polynomials for n <= 30:")
    for (i in 1..30) {
        val p = cyclotomicPolynomial(i)
        println("CP[$i] = $p")
    }
    println()

    println("Task 2:  Smallest cyclotomic polynomial with n or -n as a coefficient:")
    var n = 0
    for (i in 1..10) {
        while (true) {
            n++
            val cyclo = cyclotomicPolynomial(n)
            if (cyclo!!.hasCoefficientAbs(i)) {
                println("CP[$n] has coefficient with magnitude = $i")
                n--
                break
            }
        }
    }
}

private val COMPUTED: MutableMap<Int, Polynomial> = HashMap()
private fun cyclotomicPolynomial(n: Int): Polynomial? {
    if (COMPUTED.containsKey(n)) {
        return COMPUTED[n]
    }
    if (n == 1) {
        //  Polynomial:  x - 1
        val p = Polynomial(1, 1, -1, 0)
        COMPUTED[1] = p
        return p
    }
    val factors = getFactors(n)
    if (factors.containsKey(n)) {
        //  n prime
        val termList: MutableList<Term> = ArrayList()
        for (index in 0 until n) {
            termList.add(Term(1, index.toLong()))
        }
        val cyclo = Polynomial(termList)
        COMPUTED[n] = cyclo
        return cyclo
    } else if (factors.size == 2 && factors.containsKey(2) && factors[2] == 1 && factors.containsKey(n / 2) && factors[n / 2] == 1) {
        //  n = 2p
        val prime = n / 2
        val termList: MutableList<Term> = ArrayList()
        var coeff = -1
        for (index in 0 until prime) {
            coeff *= -1
            termList.add(Term(coeff.toLong(), index.toLong()))
        }
        val cyclo = Polynomial(termList)
        COMPUTED[n] = cyclo
        return cyclo
    } else if (factors.size == 1 && factors.containsKey(2)) {
        //  n = 2^h
        val h = factors[2]!!
        val termList: MutableList<Term> = ArrayList()
        termList.add(Term(1, 2.0.pow((h - 1).toDouble()).toLong()))
        termList.add(Term(1, 0))
        val cyclo = Polynomial(termList)
        COMPUTED[n] = cyclo
        return cyclo
    } else if (factors.size == 1 && !factors.containsKey(n)) {
        // n = p^k
        var p = 0
        for (prime in factors.keys) {
            p = prime
        }
        val k = factors[p]!!
        val termList: MutableList<Term> = ArrayList()
        for (index in 0 until p) {
            termList.add(Term(1, (index * p.toDouble().pow(k - 1.toDouble()).toInt()).toLong()))
        }
        val cyclo = Polynomial(termList)
        COMPUTED[n] = cyclo
        return cyclo
    } else if (factors.size == 2 && factors.containsKey(2)) {
        //  n = 2^h * p^k
        var p = 0
        for (prime in factors.keys) {
            if (prime != 2) {
                p = prime
            }
        }
        val termList: MutableList<Term> = ArrayList()
        var coeff = -1
        val twoExp = 2.0.pow((factors[2]!!) - 1.toDouble()).toInt()
        val k = factors[p]!!
        for (index in 0 until p) {
            coeff *= -1
            termList.add(Term(coeff.toLong(), (index * twoExp * p.toDouble().pow(k - 1.toDouble()).toInt()).toLong()))
        }
        val cyclo = Polynomial(termList)
        COMPUTED[n] = cyclo
        return cyclo
    } else if (factors.containsKey(2) && n / 2 % 2 == 1 && n / 2 > 1) {
        //  CP(2m)[x] = CP(-m)[x], n odd integer > 1
        val cycloDiv2 = cyclotomicPolynomial(n / 2)
        val termList: MutableList<Term> = ArrayList()
        for (term in cycloDiv2!!.polynomialTerms) {
            termList.add(if (term.exponent % 2 == 0L) term else term.negate())
        }
        val cyclo = Polynomial(termList)
        COMPUTED[n] = cyclo
        return cyclo
    }

    //  General Case
    return when (algorithm) {
        0 -> {
            //  Slow - uses basic definition.
            val divisors = getDivisors(n)
            //  Polynomial:  ( x^n - 1 )
            var cyclo = Polynomial(1, n, -1, 0)
            for (i in divisors) {
                val p = cyclotomicPolynomial(i)
                cyclo = cyclo.divide(p)
            }
            COMPUTED[n] = cyclo
            cyclo
        }
        1 -> {
            //  Faster.  Remove Max divisor (and all divisors of max divisor) - only one divide for all divisors of Max Divisor
            val divisors = getDivisors(n)
            var maxDivisor = Int.MIN_VALUE
            for (div in divisors) {
                maxDivisor = maxDivisor.coerceAtLeast(div)
            }
            val divisorsExceptMax: MutableList<Int> = ArrayList()
            for (div in divisors) {
                if (maxDivisor % div != 0) {
                    divisorsExceptMax.add(div)
                }
            }

            //  Polynomial:  ( x^n - 1 ) / ( x^m - 1 ), where m is the max divisor
            var cyclo = Polynomial(1, n, -1, 0).divide(Polynomial(1, maxDivisor, -1, 0))
            for (i in divisorsExceptMax) {
                val p = cyclotomicPolynomial(i)
                cyclo = cyclo.divide(p)
            }
            COMPUTED[n] = cyclo
            cyclo
        }
        2 -> {
            //  Fastest
            //  Let p ; q be primes such that p does not divide n, and q q divides n.
            //  Then CP(np)[x] = CP(n)[x^p] / CP(n)[x]
            var m = 1
            var cyclo = cyclotomicPolynomial(m)
            val primes = factors.keys.toMutableList()
            primes.sort()
            for (prime in primes) {
                //  CP(m)[x]
                val cycloM = cyclo
                //  Compute CP(m)[x^p].
                val termList: MutableList<Term> = ArrayList()
                for (t in cycloM!!.polynomialTerms) {
                    termList.add(Term(t.coefficient, t.exponent * prime))
                }
                cyclo = Polynomial(termList).divide(cycloM)
                m *= prime
            }
            //  Now, m is the largest square free divisor of n
            val s = n / m
            //  Compute CP(n)[x] = CP(m)[x^s]
            val termList: MutableList<Term> = ArrayList()
            for (t in cyclo!!.polynomialTerms) {
                termList.add(Term(t.coefficient, t.exponent * s))
            }
            cyclo = Polynomial(termList)
            COMPUTED[n] = cyclo
            cyclo
        }
        else -> {
            throw RuntimeException("ERROR 103:  Invalid algorithm.")
        }
    }
}

private fun getDivisors(number: Int): List<Int> {
    val divisors: MutableList<Int> = ArrayList()
    val sqrt = sqrt(number.toDouble()).toLong()
    for (i in 1..sqrt) {
        if (number % i == 0L) {
            divisors.add(i.toInt())
            val div = (number / i).toInt()
            if (div.toLong() != i && div != number) {
                divisors.add(div)
            }
        }
    }
    return divisors
}

private fun crutch(): MutableMap<Int, Map<Int, Int>> {
    val allFactors: MutableMap<Int, Map<Int, Int>> = TreeMap()

    val factors: MutableMap<Int, Int> = TreeMap()
    factors[2] = 1

    allFactors[2] = factors
    return allFactors
}

private val allFactors = crutch()

var MAX_ALL_FACTORS = 100000

fun getFactors(number: Int): Map<Int, Int> {
    if (allFactors.containsKey(number)) {
        return allFactors[number]!!
    }
    val factors: MutableMap<Int, Int> = TreeMap()
    if (number % 2 == 0) {
        val factorsDivTwo = getFactors(number / 2)
        factors.putAll(factorsDivTwo)
        factors.merge(2, 1) { a: Int?, b: Int? -> Integer.sum(a!!, b!!) }
        if (number < MAX_ALL_FACTORS) allFactors[number] = factors
        return factors
    }
    val sqrt = sqrt(number.toDouble()).toLong()
    var i = 3
    while (i <= sqrt) {
        if (number % i == 0) {
            factors.putAll(getFactors(number / i))
            factors.merge(i, 1) { a: Int?, b: Int? -> Integer.sum(a!!, b!!) }
            if (number < MAX_ALL_FACTORS) {
                allFactors[number] = factors
            }
            return factors
        }
        i += 2
    }
    factors[number] = 1
    if (number < MAX_ALL_FACTORS) {
        allFactors[number] = factors
    }
    return factors
}

private class Polynomial {
    val polynomialTerms: MutableList<Term>

    //  Format - coeff, exp, coeff, exp, (repeating in pairs) . . .
    constructor(vararg values: Int) {
        require(values.size % 2 == 0) { "ERROR 102:  Polynomial constructor.  Length must be even.  Length = " + values.size }
        polynomialTerms = mutableListOf()
        var i = 0
        while (i < values.size) {
            val t = Term(values[i].toLong(), values[i + 1].toLong())
            polynomialTerms.add(t)
            i += 2
        }
        polynomialTerms.sortWith(TermSorter())
    }

    constructor() {
        //  zero
        polynomialTerms = ArrayList()
        polynomialTerms.add(Term(0, 0))
    }

    fun hasCoefficientAbs(coeff: Int): Boolean {
        for (term in polynomialTerms) {
            if (abs(term.coefficient) == coeff.toLong()) {
                return true
            }
        }
        return false
    }

    constructor(termList: MutableList<Term>) {
        if (termList.isEmpty()) {
            //  zero
            termList.add(Term(0, 0))
        } else {
            //  Remove zero terms if needed
            termList.removeIf { t -> t.coefficient == 0L }
        }
        if (termList.size == 0) {
            //  zero
            termList.add(Term(0, 0))
        }
        polynomialTerms = termList
        polynomialTerms.sortWith(TermSorter())
    }

    fun divide(v: Polynomial?): Polynomial {
        var q = Polynomial()
        var r = this
        val lcv = v!!.leadingCoefficient()
        val dv = v.degree()
        while (r.degree() >= v.degree()) {
            val lcr = r.leadingCoefficient()
            val s = lcr / lcv //  Integer division
            val term = Term(s, r.degree() - dv)
            q = q.add(term)
            r = r.add(v.multiply(term.negate()))
        }
        return q
    }

    fun add(polynomial: Polynomial): Polynomial {
        val termList: MutableList<Term> = ArrayList()
        var thisCount = polynomialTerms.size
        var polyCount = polynomial.polynomialTerms.size
        while (thisCount > 0 || polyCount > 0) {
            val thisTerm = if (thisCount == 0) null else polynomialTerms[thisCount - 1]
            val polyTerm = if (polyCount == 0) null else polynomial.polynomialTerms[polyCount - 1]
            when {
                thisTerm == null -> {
                    termList.add(polyTerm!!.clone())
                    polyCount--
                }
                polyTerm == null -> {
                    termList.add(thisTerm.clone())
                    thisCount--
                }
                thisTerm.degree() == polyTerm.degree() -> {
                    val t = thisTerm.add(polyTerm)
                    if (t.coefficient != 0L) {
                        termList.add(t)
                    }
                    thisCount--
                    polyCount--
                }
                thisTerm.degree() < polyTerm.degree() -> {
                    termList.add(thisTerm.clone())
                    thisCount--
                }
                else -> {
                    termList.add(polyTerm.clone())
                    polyCount--
                }
            }
        }
        return Polynomial(termList)
    }

    fun add(term: Term): Polynomial {
        val termList: MutableList<Term> = ArrayList()
        var added = false
        for (currentTerm in polynomialTerms) {
            if (currentTerm.exponent == term.exponent) {
                added = true
                if (currentTerm.coefficient + term.coefficient != 0L) {
                    termList.add(currentTerm.add(term))
                }
            } else {
                termList.add(currentTerm.clone())
            }
        }
        if (!added) {
            termList.add(term.clone())
        }
        return Polynomial(termList)
    }

    fun multiply(term: Term): Polynomial {
        val termList: MutableList<Term> = ArrayList()
        for (currentTerm in polynomialTerms) {
            termList.add(currentTerm.clone().multiply(term))
        }
        return Polynomial(termList)
    }

    fun leadingCoefficient(): Long {
        return polynomialTerms[0].coefficient
    }

    fun degree(): Long {
        return polynomialTerms[0].exponent
    }

    override fun toString(): String {
        val sb = StringBuilder()
        var first = true
        for (term in polynomialTerms) {
            if (first) {
                sb.append(term)
                first = false
            } else {
                sb.append(" ")
                if (term.coefficient > 0) {
                    sb.append("+ ")
                    sb.append(term)
                } else {
                    sb.append("- ")
                    sb.append(term.negate())
                }
            }
        }
        return sb.toString()
    }
}

private class TermSorter : Comparator<Term> {
    override fun compare(o1: Term, o2: Term): Int {
        return (o2.exponent - o1.exponent).toInt()
    }
}

//  Note:  Cyclotomic Polynomials have small coefficients.  Not appropriate for general polynomial usage.
private class Term(var coefficient: Long, var exponent: Long) {
    fun clone(): Term {
        return Term(coefficient, exponent)
    }

    fun multiply(term: Term): Term {
        return Term(coefficient * term.coefficient, exponent + term.exponent)
    }

    fun add(term: Term): Term {
        if (exponent != term.exponent) {
            throw RuntimeException("ERROR 102:  Exponents not equal.")
        }
        return Term(coefficient + term.coefficient, exponent)
    }

    fun negate(): Term {
        return Term(-coefficient, exponent)
    }

    fun degree(): Long {
        return exponent
    }

    override fun toString(): String {
        if (coefficient == 0L) {
            return "0"
        }
        if (exponent == 0L) {
            return "" + coefficient
        }
        if (coefficient == 1L) {
            return if (exponent == 1L) {
                "x"
            } else {
                "x^$exponent"
            }
        }
        return if (exponent == 1L) {
            coefficient.toString() + "x"
        } else coefficient.toString() + "x^" + exponent
    }
}
