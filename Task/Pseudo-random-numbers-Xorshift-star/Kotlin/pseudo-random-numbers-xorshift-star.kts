import kotlin.math.floor

class XorShiftStar {
    private var state = 0L

    fun seed(num: Long) {
        state = num
    }

    fun nextInt(): Int {
        var x = state
        x = x xor (x ushr 12)
        x = x xor (x shl 25)
        x = x xor (x ushr 27)
        state = x

        return (x * MAGIC shr 32).toInt()
    }

    fun nextFloat(): Float {
        return nextInt().toUInt().toFloat() / (1L shl 32)
    }

    companion object {
        private const val MAGIC = 0x2545F4914F6CDD1D
    }
}

fun main() {
    val rng = XorShiftStar()

    rng.seed(1234567)
    println(rng.nextInt().toUInt())
    println(rng.nextInt().toUInt())
    println(rng.nextInt().toUInt())
    println(rng.nextInt().toUInt())
    println(rng.nextInt().toUInt())
    println()

    rng.seed(987654321)
    val counts = arrayOf(0, 0, 0, 0, 0)
    for (i in 1..100000) {
        val j = floor(rng.nextFloat() * 5.0).toInt()
        counts[j]++
    }
    for (iv in counts.withIndex()) {
        println("${iv.index}: ${iv.value}")
    }
}
