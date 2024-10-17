// version 1.1.2

import java.math.BigInteger

fun nextLeftTruncatablePrimes(n: BigInteger, radix: Int, certainty: Int): List<BigInteger> {
    val probablePrimes = mutableListOf<BigInteger>()
    val baseString = if (n == BigInteger.ZERO) "" else n.toString(radix)
    for (i in 1 until radix) {
        val p = BigInteger(i.toString(radix) + baseString, radix)
        if (p.isProbablePrime(certainty)) probablePrimes.add(p)
    }
    return probablePrimes
}

fun largestLeftTruncatablePrime(radix: Int, certainty: Int): BigInteger? {
    var lastList: List<BigInteger>? = null
    var list = nextLeftTruncatablePrimes(BigInteger.ZERO, radix, certainty)
    while (!list.isEmpty()) {
        lastList = list
        list = mutableListOf()
        for (n in lastList) list.addAll(nextLeftTruncatablePrimes(n, radix, certainty))
    }
    if (lastList == null) return null
    return lastList.sorted().last()
}

fun main(args: Array<String>) {
    print("Enter maximum radix : ")
    val maxRadix = readLine()!!.toInt()
    print("Enter certainty     : ")
    val certainty = readLine()!!.toInt()
    println()
    for (radix in 3..maxRadix) {
        val largest = largestLeftTruncatablePrime(radix, certainty)
        print("Base = ${"%-2d".format(radix)} : ")
        if (largest == null)
            println("No left truncatable prime")
        else
            println("${largest.toString().padEnd(35)} -> ${largest.toString(radix)}")
    }
}
