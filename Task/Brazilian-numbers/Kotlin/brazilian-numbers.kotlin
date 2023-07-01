fun sameDigits(n: Int, b: Int): Boolean {
    var n2 = n
    val f = n % b
    while (true) {
        n2 /= b
        if (n2 > 0) {
            if (n2 % b != f) {
                return false
            }
        } else {
            break
        }
    }
    return true
}

fun isBrazilian(n: Int): Boolean {
    if (n < 7) return false
    if (n % 2 == 0) return true
    for (b in 2 until n - 1) {
        if (sameDigits(n, b)) {
            return true
        }
    }
    return false
}

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

fun main() {
    val bigLim = 99999
    val limit = 20
    for (kind in ",odd ,prime".split(',')) {
        var quiet = false
        println("First $limit ${kind}Brazilian numbers:")
        var c = 0
        var n = 7
        while (c < bigLim) {
            if (isBrazilian(n)) {
                if (!quiet) print("%,d ".format(n))
                if (++c == limit) {
                    print("\n\n")
                    quiet = true
                }
            }
            if (quiet && kind != "") continue
            when (kind) {
                "" -> n++
                "odd " -> n += 2
                "prime" -> {
                    while (true) {
                        n += 2
                        if (isPrime(n)) break
                    }
                }
            }
        }
        if (kind == "") println("The %,dth Brazilian number is: %,d".format(bigLim + 1, n))
    }
}
