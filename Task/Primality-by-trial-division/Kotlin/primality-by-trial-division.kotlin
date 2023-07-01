// version 1.1.2
fun isPrime(n: Int): Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    val limit = Math.sqrt(n.toDouble()).toInt()
    return (3..limit step 2).none { n % it == 0 }
}

fun main(args: Array<String>) {
    // test by printing all primes below 100 say
    (2..99).filter { isPrime(it) }.forEach { print("$it ") }
}
