import kotlin.math.floor

fun mod(x: Long, y: Long): Long {
    val m = x % y
    return if (m < 0) {
        if (y < 0) {
            m - y
        } else {
            m + y
        }
    } else m
}

class RNG {
    // first generator
    private val a1 = arrayOf(0L, 1403580L, -810728L)
    private val m1 = (1L shl 32) - 209
    private var x1 = arrayOf(0L, 0L, 0L)

    // second generator
    private val a2 = arrayOf(527612L, 0L, -1370589L)
    private val m2 = (1L shl 32) - 22853
    private var x2 = arrayOf(0L, 0L, 0L)

    private val d = m1 + 1

    fun seed(state: Long) {
        x1 = arrayOf(state, 0, 0)
        x2 = arrayOf(state, 0, 0)
    }

    fun nextInt(): Long {
        val x1i = mod(a1[0] * x1[0] + a1[1] * x1[1] + a1[2] * x1[2], m1)
        val x2i = mod(a2[0] * x2[0] + a2[1] * x2[1] + a2[2] * x2[2], m2)
        val z = mod(x1i - x2i, m1)

        // keep last three values of the first generator
        x1 = arrayOf(x1i, x1[0], x1[1])
        // keep last three values of the second generator
        x2 = arrayOf(x2i, x2[0], x2[1])

        return z + 1
    }

    fun nextFloat(): Double {
        return nextInt().toDouble() / d
    }
}

fun main() {
    val rng = RNG()

    rng.seed(1234567)
    println(rng.nextInt())
    println(rng.nextInt())
    println(rng.nextInt())
    println(rng.nextInt())
    println(rng.nextInt())
    println()

    val counts = IntArray(5)
    rng.seed(987654321)
    for (i in 0 until 100_000) {
        val v = floor((rng.nextFloat() * 5.0)).toInt()
        counts[v]++
    }
    for (iv in counts.withIndex()) {
        println("${iv.index}: ${iv.value}")
    }
}
