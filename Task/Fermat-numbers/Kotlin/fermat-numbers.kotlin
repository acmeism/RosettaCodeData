import java.math.BigInteger
import kotlin.math.pow

fun main() {
    println("First 10 Fermat numbers:")
    for (i in 0..9) {
        println("F[$i] = ${fermat(i)}")
    }
    println()
    println("First 12 Fermat numbers factored:")
    for (i in 0..12) {
        println("F[$i] = ${getString(getFactors(i, fermat(i)))}")
    }
}

private fun getString(factors: List<BigInteger>): String {
    return if (factors.size == 1) {
        "${factors[0]} (PRIME)"
    } else factors.map { it.toString() }
        .joinToString(" * ") {
            if (it.startsWith("-"))
                "(C" + it.replace("-", "") + ")"
            else it
        }
}

private val COMPOSITE = mutableMapOf(
    9 to "5529",
    10 to "6078",
    11 to "1037",
    12 to "5488",
    13 to "2884"
)

private fun getFactors(fermatIndex: Int, n: BigInteger): List<BigInteger> {
    var n2 = n
    val factors: MutableList<BigInteger> = ArrayList()
    var factor: BigInteger
    while (true) {
        if (n2.isProbablePrime(100)) {
            factors.add(n2)
            break
        } else {
            if (COMPOSITE.containsKey(fermatIndex)) {
                val stop = COMPOSITE[fermatIndex]
                if (n2.toString().startsWith(stop!!)) {
                    factors.add(BigInteger("-" + n2.toString().length))
                    break
                }
            }
            //factor = pollardRho(n)
            factor = pollardRhoFast(n)
            n2 = if (factor.compareTo(BigInteger.ZERO) == 0) {
                factors.add(n2)
                break
            } else {
                factors.add(factor)
                n2.divide(factor)
            }
        }
    }
    return factors
}

private val TWO = BigInteger.valueOf(2)
private fun fermat(n: Int): BigInteger {
    return TWO.pow(2.0.pow(n.toDouble()).toInt()).add(BigInteger.ONE)
}

//  See:  https://en.wikipedia.org/wiki/Pollard%27s_rho_algorithm
@Suppress("unused")
private fun pollardRho(n: BigInteger): BigInteger {
    var x = BigInteger.valueOf(2)
    var y = BigInteger.valueOf(2)
    var d = BigInteger.ONE
    while (d.compareTo(BigInteger.ONE) == 0) {
        x = pollardRhoG(x, n)
        y = pollardRhoG(pollardRhoG(y, n), n)
        d = (x - y).abs().gcd(n)
    }
    return if (d.compareTo(n) == 0) {
        BigInteger.ZERO
    } else d
}

//  Includes Speed Up of 100 multiples and 1 GCD, instead of 100 multiples and 100 GCDs.
//  See Variants section of Wikipedia article.
//  Testing F[8] = 1238926361552897 * Prime
//    This variant = 32 sec.
//    Standard algorithm = 107 sec.
private fun pollardRhoFast(n: BigInteger): BigInteger {
    val start = System.currentTimeMillis()
    var x = BigInteger.valueOf(2)
    var y = BigInteger.valueOf(2)
    var d: BigInteger
    var count = 0
    var z = BigInteger.ONE
    while (true) {
        x = pollardRhoG(x, n)
        y = pollardRhoG(pollardRhoG(y, n), n)
        d = (x - y).abs()
        z = (z * d).mod(n)
        count++
        if (count == 100) {
            d = z.gcd(n)
            if (d.compareTo(BigInteger.ONE) != 0) {
                break
            }
            z = BigInteger.ONE
            count = 0
        }
    }
    val end = System.currentTimeMillis()
    println("    Pollard rho try factor $n elapsed time = ${end - start} ms (factor = $d).")
    return if (d.compareTo(n) == 0) {
        BigInteger.ZERO
    } else d
}

private fun pollardRhoG(x: BigInteger, n: BigInteger): BigInteger {
    return (x * x + BigInteger.ONE).mod(n)
}
