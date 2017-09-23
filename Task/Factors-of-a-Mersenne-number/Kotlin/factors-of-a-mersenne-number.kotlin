// version 1.0.6

fun isPrime(n: Int): Boolean {
    if (n < 2) return false
    if (n % 2 == 0) return n == 2
    if (n % 3 == 0) return n == 3
    var d = 5
    while (d * d <= n) {
        if (n % d == 0) return false
        d += 2
        if (n % d == 0) return false
        d += 4
    }
    return true
}

fun main(args: Array<String>) {
    // test 929 plus all prime numbers below 100 which are known not to be Mersenne primes
    val q = intArrayOf(11, 23, 29, 37, 41, 43, 47, 53, 59, 67, 71, 73, 79, 83, 97, 929)
    for (k in 0 until q.size) {
        if (isPrime(q[k])) {
            var i: Long
            var d: Int
            var p: Int
            var r: Int = q[k]
            while (r > 0) r = r shl 1
            d = 2 * q[k] + 1
            while (true) {
                i = 1L
                p = r
                while (p != 0) {
                    i = (i * i) % d
                    if (p < 0) i *= 2
                    if (i > d) i -= d
                    p = p shl 1
                }
                if (i != 1L)
                    d += 2 * q[k]
                else
                    break
            }
            println("2^${"%3d".format(q[k])} - 1 = 0 (mod $d)")
        } else {
            println("${q[k]} is not prime")
        }
    }
}
