private const val MAX = 10000000
private val primes = BooleanArray(MAX)

fun main() {
    sieve()
    println("First 35 unprimeable numbers:")
    displayUnprimeableNumbers(35)
    val n = 600
    println()
    println("The ${n}th unprimeable number = ${nthUnprimeableNumber(n)}")
    println()
    val lowest = genLowest()
    println("Least unprimeable number that ends in:")
    for (i in 0..9) {
        println(" $i is ${lowest[i]}")
    }
}

private fun genLowest(): IntArray {
    val lowest = IntArray(10)
    var count = 0
    var test = 1
    while (count < 10) {
        test++
        if (unPrimable(test) && lowest[test % 10] == 0) {
            lowest[test % 10] = test
            count++
        }
    }
    return lowest
}

private fun nthUnprimeableNumber(maxCount: Int): Int {
    var test = 1
    var count = 0
    var result = 0
    while (count < maxCount) {
        test++
        if (unPrimable(test)) {
            count++
            result = test
        }
    }
    return result
}

private fun displayUnprimeableNumbers(maxCount: Int) {
    var test = 1
    var count = 0
    while (count < maxCount) {
        test++
        if (unPrimable(test)) {
            count++
            print("$test ")
        }
    }
    println()
}

private fun unPrimable(test: Int): Boolean {
    if (primes[test]) {
        return false
    }
    val s = test.toString() + ""
    for (i in s.indices) {
        for (j in 0..9) {
            if (primes[replace(s, i, j).toInt()]) {
                return false
            }
        }
    }
    return true
}

private fun replace(str: String, position: Int, value: Int): String {
    val sChar = str.toCharArray()
    sChar[position] = value.toChar()
    return str.substring(0, position) + value + str.substring(position + 1)
}

private fun sieve() {
    //  primes
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
