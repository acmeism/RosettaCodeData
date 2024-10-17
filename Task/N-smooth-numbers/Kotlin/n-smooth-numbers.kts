import java.math.BigInteger

var primes = mutableListOf<BigInteger>()
var smallPrimes = mutableListOf<Int>()

// cache all primes up to 521
fun init() {
    val two = BigInteger.valueOf(2)
    val three = BigInteger.valueOf(3)
    val p521 = BigInteger.valueOf(521)
    val p29 = BigInteger.valueOf(29)
    primes.add(two)
    smallPrimes.add(2)
    var i = three
    while (i <= p521) {
        if (i.isProbablePrime(1)) {
            primes.add(i)
            if (i <= p29) {
                smallPrimes.add(i.toInt())
            }
        }
        i += two
    }
}

fun min(bs: List<BigInteger>): BigInteger {
    require(bs.isNotEmpty()) { "slice must have at lease one element" }
    val it = bs.iterator()
    var res = it.next()
    while (it.hasNext()) {
        val t = it.next()
        if (t < res) {
            res = t
        }
    }
    return res
}

fun nSmooth(n: Int, size: Int): List<BigInteger> {
    require(n in 2..521) { "n must be between 2 and 521" }
    require(size >= 1) { "size must be at least 1" }

    val bn = BigInteger.valueOf(n.toLong())
    var ok = false
    for (prime in primes) {
        if (bn == prime) {
            ok = true
            break
        }
    }
    require(ok) { "n must be a prime number" }

    val ns = Array<BigInteger>(size) { BigInteger.ZERO }
    ns[0] = BigInteger.ONE
    val next = mutableListOf<BigInteger>()
    for (i in 0 until primes.size) {
        if (primes[i] > bn) {
            break
        }
        next.add(primes[i])
    }
    val indices = Array(next.size) { 0 }
    for (m in 1 until size) {
        ns[m] = min(next)
        for (i in indices.indices) {
            if (ns[m] == next[i]) {
                indices[i]++
                next[i] = primes[i] * ns[indices[i]]
            }
        }
    }

    return ns.toList()
}

fun main() {
    init()
    for (i in smallPrimes) {
        println("The first 25 $i-smooth numbers are:")
        println(nSmooth(i, 25))
        println()
    }
    for (i in smallPrimes.drop(1)) {
        println("The 3,000th to 3,202 $i-smooth numbers are:")
        println(nSmooth(i, 3_002).drop(2_999))
        println()
    }
    for (i in listOf(503, 509, 521)) {
        println("The 30,000th to 30,019 $i-smooth numbers are:")
        println(nSmooth(i, 30_019).drop(29_999))
        println()
    }
}
