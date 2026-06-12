object MainKt {
    @JvmStatic
    fun main(args: Array<String>) {
        val sequences = arrayOf(
            longArrayOf(1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440, 9694845),
            longArrayOf(0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0),
            longArrayOf(0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181),
            longArrayOf(1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37)
        )
        val names = arrayOf(
            "Catalan number sequence:",
            "Prime flip-flop sequence:",
            "Fibonacci number sequence:",
            "Padovan number sequence:"
        )

        for (i in sequences.indices) {
            println(names[i])
            println(sequences[i].contentToString())
            println("Forward binomial transform:")
            println(forward(sequences[i]).contentToString())
            println("Inverse binomial transform:")
            println(inverse(sequences[i]).contentToString())
            println("Round trip:")
            println(inverse(forward(sequences[i])).contentToString())
            println("Self-inverting:")
            println(selfInverting(sequences[i]).contentToString())
            println("Round trip self-inverting:")
            println(selfInverting(selfInverting(sequences[i])).contentToString())
            println()
        }
    }

    private fun selfInverting(numbers: LongArray): LongArray {
        val transform = LongArray(numbers.size)
        for (n in numbers.indices) {
            for (k in 0..n) {
                val sign = if (k % 2 == 1) -1 else 1
                transform[n] += binomial(n, k) * numbers[k] * sign
            }
        }
        return transform
    }

    private fun inverse(numbers: LongArray): LongArray {
        val transform = LongArray(numbers.size)
        for (n in numbers.indices) {
            for (k in 0..n) {
                val sign = if ((n - k) % 2 == 1) -1 else 1
                transform[n] += binomial(n, k) * numbers[k] * sign
            }
        }
        return transform
    }

    private fun forward(numbers: LongArray): LongArray {
        val transform = LongArray(numbers.size)
        for (n in numbers.indices) {
            for (k in 0..n) {
                transform[n] += binomial(n, k) * numbers[k]
            }
        }
        return transform
    }

    private fun binomial(n: Int, k: Int): Long {
        return factorial(n) / factorial(n - k) / factorial(k)
    }

    private fun factorial(number: Int): Long {
        require(number <= 20) { "Factorial of number is too large: $number" }
        if (number < 2) {
            return 1
        }
        var factorial = 1L
        for (i in 2..number) {
            factorial *= i
        }
        return factorial
    }
}

