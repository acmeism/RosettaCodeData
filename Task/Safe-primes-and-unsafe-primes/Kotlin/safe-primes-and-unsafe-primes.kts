// Version 1.2.70

fun sieve(limit: Int): BooleanArray {
    // True denotes composite, false denotes prime.
    val c = BooleanArray(limit + 1) // all false by default
    c[0] = true
    c[1] = true
    // apart from 2 all even numbers are of course composite
    for (i in 4..limit step 2) c[i] = true
    var p = 3 // start from 3
    while (true) {
        val p2 = p * p
        if (p2 > limit) break
        for (i in p2..limit step 2 * p) c[i] = true
        while (true) {
            p += 2
            if (!c[p]) break
        }
    }
    return c
}

fun main(args: Array<String>) {
    // sieve up to 10 million
    val sieved = sieve(10_000_000)
    val safe = IntArray(35)
    var count = 0
    var i = 3
    while (count < 35) {
        if (!sieved[i] && !sieved[(i - 1) / 2]) safe[count++] = i
        i += 2
    }
    println("The first 35 safe primes are:")
    println(safe.joinToString(" ","[", "]\n"))

    count = 0
    for (j in 3 until 1_000_000 step 2) {
        if (!sieved[j] && !sieved[(j - 1) / 2]) count++
    }
    System.out.printf("The number of safe primes below 1,000,000 is %,d\n\n", count)

    for (j in 1_000_001 until 10_000_000 step 2) {
        if (!sieved[j] && !sieved[(j - 1) / 2]) count++
    }
    System.out.printf("The number of safe primes below 10,000,000 is %,d\n\n", count)

    val unsafe = IntArray(40)
    unsafe[0] = 2  // since (2 - 1)/2 is not prime
    count = 1
    i = 3
    while (count < 40) {
        if (!sieved[i] && sieved[(i - 1) / 2]) unsafe[count++] = i
        i += 2
    }
    println("The first 40 unsafe primes are:")
    println(unsafe.joinToString(" ","[", "]\n"))

    count = 1
    for (j in 3 until 1_000_000 step 2) {
        if (!sieved[j] && sieved[(j - 1) / 2]) count++
    }
    System.out.printf("The number of unsafe primes below 1,000,000 is %,d\n\n", count)

    for (j in 1_000_001 until 10_000_000 step 2) {
        if (!sieved[j] && sieved[(j - 1) / 2]) count++
    }
    System.out.printf("The number of unsafe primes below 10,000,000 is %,d\n\n", count)
}
