object Ulam {
    fun generate(n: Int, i: Int = 1, c: Char = '*') {
        require(n > 1)
        val s = Array(n) { Array(n, { "" }) }
        var dir = Direction.RIGHT
        var y = n / 2
        var x = if (n % 2 == 0) y - 1 else y // shift left for even n's
        for (j in i..n * n - 1 + i) {
            s[y][x] = if (isPrime(j)) if (c.isDigit()) "%4d".format(j) else "  $c " else " ---"

            when (dir) {
                Direction.RIGHT -> if (x <= n - 1 && s[y - 1][x].none() && j > i) dir = Direction.UP
                Direction.UP -> if (s[y][x - 1].none()) dir = Direction.LEFT
                Direction.LEFT -> if (x == 0 || s[y + 1][x].none()) dir = Direction.DOWN
                Direction.DOWN -> if (s[y][x + 1].none()) dir = Direction.RIGHT
            }

            when (dir) {
                Direction.RIGHT -> x++
                Direction.UP -> y--
                Direction.LEFT -> x--
                Direction.DOWN -> y++
            }
        }
        for (row in s) println("[" + row.joinToString("") + ']')
        println()
    }

    private enum class Direction { RIGHT, UP, LEFT, DOWN }

    private fun isPrime(a: Int): Boolean {
        when {
            a == 2 -> return true
            a <= 1 || a % 2 == 0 -> return false
            else -> {
                val max = Math.sqrt(a.toDouble()).toInt()
                for (n in 3..max step 2)
                    if (a % n == 0) return false
                return true
            }
        }
    }
}

fun main(args: Array<String>) {
    Ulam.generate(9, c = '0')
    Ulam.generate(9)
}
