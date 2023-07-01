private const val MAX = 10000000 + 1000
private val primes = BooleanArray(MAX)

fun main() {
    sieve()

    println("First 36 strong primes:")
    displayStrongPrimes(36)
    for (n in intArrayOf(1000000, 10000000)) {
        System.out.printf("Number of strong primes below %,d = %,d%n", n, strongPrimesBelow(n))
    }

    println("First 37 weak primes:")
    displayWeakPrimes(37)
    for (n in intArrayOf(1000000, 10000000)) {
        System.out.printf("Number of weak primes below %,d = %,d%n", n, weakPrimesBelow(n))
    }
}

private fun weakPrimesBelow(maxPrime: Int): Int {
    var priorPrime = 2
    var currentPrime = 3
    var count = 0
    while (currentPrime < maxPrime) {
        val nextPrime = getNextPrime(currentPrime)
        if (currentPrime * 2 < priorPrime + nextPrime) {
            count++
        }
        priorPrime = currentPrime
        currentPrime = nextPrime
    }
    return count
}

private fun displayWeakPrimes(maxCount: Int) {
    var priorPrime = 2
    var currentPrime = 3
    var count = 0
    while (count < maxCount) {
        val nextPrime = getNextPrime(currentPrime)
        if (currentPrime * 2 < priorPrime + nextPrime) {
            count++
            print("$currentPrime ")
        }
        priorPrime = currentPrime
        currentPrime = nextPrime
    }
    println()
}

private fun getNextPrime(currentPrime: Int): Int {
    var nextPrime = currentPrime + 2
    while (!primes[nextPrime]) {
        nextPrime += 2
    }
    return nextPrime
}

private fun strongPrimesBelow(maxPrime: Int): Int {
    var priorPrime = 2
    var currentPrime = 3
    var count = 0
    while (currentPrime < maxPrime) {
        val nextPrime = getNextPrime(currentPrime)
        if (currentPrime * 2 > priorPrime + nextPrime) {
            count++
        }
        priorPrime = currentPrime
        currentPrime = nextPrime
    }
    return count
}

private fun displayStrongPrimes(maxCount: Int) {
    var priorPrime = 2
    var currentPrime = 3
    var count = 0
    while (count < maxCount) {
        val nextPrime = getNextPrime(currentPrime)
        if (currentPrime * 2 > priorPrime + nextPrime) {
            count++
            print("$currentPrime ")
        }
        priorPrime = currentPrime
        currentPrime = nextPrime
    }
    println()
}

private fun sieve() { //  primes
    for (i in 2 until MAX) {
        primes[i] = true
    }
    for (i in 2 until MAX) {
        if (primes[i]) {
            var j = 2 * i
            while (j < MAX) {
                primes[j] = false
                j += i
            }
        }
    }
}
