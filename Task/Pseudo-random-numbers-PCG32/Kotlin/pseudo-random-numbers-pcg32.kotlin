import kotlin.math.floor

class PCG32 {
    private var state = 0x853c49e6748fea9buL
    private var inc = 0xda3e39cb94b95bdbuL

    fun nextInt(): UInt {
        val old = state
        state = old * N + inc
        val shifted = old.shr(18).xor(old).shr(27).toUInt()
        val rot = old.shr(59)
        return (shifted shr rot.toInt()) or shifted.shl((rot.inv() + 1u).and(31u).toInt())
    }

    fun nextFloat(): Double {
        return nextInt().toDouble() / (1L shl 32)
    }

    fun seed(seedState: ULong, seedSequence: ULong) {
        state = 0u
        inc = (seedSequence shl 1).or(1uL)
        nextInt()
        state += seedState
        nextInt()
    }

    companion object {
        private const val N = 6364136223846793005uL
    }
}

fun main() {
    val r = PCG32()

    r.seed(42u, 54u)
    println(r.nextInt())
    println(r.nextInt())
    println(r.nextInt())
    println(r.nextInt())
    println(r.nextInt())
    println()

    val counts = Array(5) { 0 }
    r.seed(987654321u, 1u)
    for (i in 0 until 100000) {
        val j = floor(r.nextFloat() * 5.0).toInt()
        counts[j] += 1
    }

    println("The counts for 100,000 repetitions are:")
    for (iv in counts.withIndex()) {
        println("  %d : %d".format(iv.index, iv.value))
    }
}
