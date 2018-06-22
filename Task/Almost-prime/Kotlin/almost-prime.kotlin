fun Int.k_prime(x: Int): Boolean {
    var n = x
    var f = 0
    var p = 2
    while (f < this && p * p <= n) {
        while (0 == n % p) { n /= p; f++ }
        p++
    }
    return f + (if (n > 1) 1 else 0) == this
}

fun Int.primes(n : Int) : List<Int> {
    var i = 2
    var list = mutableListOf<Int>()
    while (list.size < n) {
        if (k_prime(i)) list.add(i)
        i++
    }
    return list
}

fun main(args: Array<String>) {
    for (k in 1..5)
        println("k = $k: " + k.primes(10))
}
