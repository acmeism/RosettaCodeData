// version 1.0.6

infix fun Int.ipow(exp: Int): Int =
    when {
        this ==  1 -> 1
        this == -1 -> if (exp and 1 == 0) 1 else -1
        exp <  0   -> throw IllegalArgumentException("invalid exponent")
        exp == 0   -> 1
        else       -> {
            var ans = 1
            var base = this
            var e = exp
            while (e > 1) {
                if (e and 1 == 1) ans *= base
                e = e shr 1
                base *= base
            }
            ans * base
        }
    }

infix fun Double.dpow(exp: Int): Double {
    var ans = 1.0
    var e   = exp
    var base = if (e < 0) 1.0 / this else this
    if (e < 0) e = -e
    while (e > 0) {
        if (e and 1 == 1) ans *= base
        e = e shr 1
        base *= base
    }
    return ans
}

fun main(args: Array<String>) {
    println("2  ^ 3   = ${2 ipow 3}")
    println("1  ^ -10 = ${1 ipow -10}")
    println("-1 ^ -3  = ${-1 ipow -3}")
    println()
    println("2.0 ^ -3 = ${2.0 dpow -3}")
    println("1.5 ^ 0  = ${1.5 dpow 0}")
    println("4.5 ^ 2  = ${4.5 dpow 2}")
}
