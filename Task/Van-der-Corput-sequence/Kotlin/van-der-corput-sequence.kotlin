// version 1.1.2

data class Rational(val num: Int, val denom: Int)

fun vdc(n: Int, base: Int): Rational {
    var p = 0
    var q = 1
    var nn = n
    while (nn != 0) {
        p = p * base + nn % base
        q *= base
        nn /= base
    }
    val num = p
    val denom = q
    while (p != 0) {
        nn = p
        p = q % p
        q = nn
    }
    return Rational(num / q, denom / q)
}

fun main(args: Array<String>) {
    for (b in 2..5) {
        print("base $b:")
        for (i in 0..9) {
            val(num, denom) = vdc(i, b)
            if (num != 0) print("  $num/$denom")
            else print("  0")
        }
        println()
    }
}
