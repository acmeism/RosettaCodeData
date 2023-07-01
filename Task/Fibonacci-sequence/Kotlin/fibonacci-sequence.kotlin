enum class Fibonacci {
    ITERATIVE {
        override fun get(n: Int): Long = if (n < 2) {
            n.toLong()
        } else {
            var n1 = 0L
            var n2 = 1L
            repeat(n) {
                val sum = n1 + n2
                n1 = n2
                n2 = sum
            }
            n1
        }
    },
    RECURSIVE {
        override fun get(n: Int): Long = if (n < 2) n.toLong() else this[n - 1] + this[n - 2]
    },
    CACHING {
        val cache: MutableMap<Int, Long> = mutableMapOf(0 to 0L, 1 to 1L)
        override fun get(n: Int): Long = if (n < 2) n.toLong() else impl(n)
        private fun impl(n: Int): Long = cache.computeIfAbsent(n) { impl(it-1) + impl(it-2) }
    },
    ;

    abstract operator fun get(n: Int): Long
}

fun main() {
    val r = 0..30
    for (fib in Fibonacci.values()) {
        print("${fib.name.padEnd(10)}:")
        for (i in r) { print(" " + fib[i]) }
        println()
    }
}
