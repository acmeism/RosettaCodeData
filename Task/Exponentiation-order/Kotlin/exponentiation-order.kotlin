// version 1.0.5-2

infix fun Int.ipow(exp: Int): Int = when {
    exp < 0   -> throw IllegalArgumentException("negative exponents not allowed")
    exp == 0  -> 1
    else      -> {
        var ans = 1
        var base = this
        var e = exp
        while(e != 0) {
            if (e and 1 == 1) ans *= base
            e = e shr 1
            base *= base
        }
        ans
    }
}

fun main(args: Array<String>) {
    println("5**3**2   = ${5 ipow 3 ipow 2}")
    println("(5**3)**2 = ${(5 ipow 3) ipow 2}")
    println("5**(3**2) = ${5 ipow (3 ipow 2)}")
}
