fun Int.halve()  = this shr 1
fun Int.double() = this shl 1
fun Int.isOdd()  = this and 1 == 1


fun ethiopianMultiply(n: Int, m: Int): Int =
    generateSequence(Pair(n, m)) { p -> Pair(p.first.halve(), p.second.double()) }
        .takeWhile { it.first >= 1 }.filter { it.first.isOdd() }.sumOf { it.second }

fun main() {
    ethiopianMultiply(17, 34).also { println(it) } // 578
    ethiopianMultiply(99, 99).also { println(it) } // 9801
    ethiopianMultiply(4, 8).also { println(it) }   // 32
}
