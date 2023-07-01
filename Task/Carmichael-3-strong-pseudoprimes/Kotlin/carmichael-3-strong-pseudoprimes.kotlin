fun Int.isPrime(): Boolean {
    return when {
        this == 2 -> true
        this <= 1 || this % 2 == 0 -> false
        else -> {
            val max = Math.sqrt(toDouble()).toInt()
            (3..max step 2)
                .filter { this % it == 0 }
                .forEach { return false }
            true
        }
    }
}

fun mod(n: Int, m: Int) = ((n % m) + m) % m

fun main(args: Array<String>) {
    for (p1 in 3..61) {
        if (p1.isPrime()) {
            for (h3 in 2 until p1) {
                val g = h3 + p1
                for (d in 1 until g) {
                    if ((g * (p1 - 1)) % d == 0 && mod(-p1 * p1, h3) == d % h3) {
                        val q = 1 + (p1 - 1) * g / d
                        if (q.isPrime()) {
                            val r = 1 + (p1 * q / h3)
                            if (r.isPrime() && (q * r) % (p1 - 1) == 1) {
                                println("$p1 x $q x $r")
                            }
                        }
                    }
                }
            }
        }
    }
}
