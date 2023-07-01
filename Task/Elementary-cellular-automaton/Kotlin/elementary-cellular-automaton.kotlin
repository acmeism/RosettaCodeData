// version 1.1.51

import java.util.BitSet

const val SIZE  = 32
const val LINES = SIZE / 2
const val RULE  = 90

fun ruleTest(x: Int) = (RULE and (1 shl (7 and x))) != 0

infix fun Boolean.shl(bitCount: Int) = (if (this) 1 else 0) shl bitCount

fun Boolean.toInt() = if (this) 1 else 0

fun evolve(s: BitSet) {
    val t = BitSet(SIZE)  // all false by default
    t[SIZE - 1] = ruleTest((s[0] shl 2) or (s[SIZE - 1] shl 1) or s[SIZE - 2].toInt())
    t[0] = ruleTest((s[1] shl 2) or (s[0] shl 1) or s[SIZE - 1].toInt())
    for (i in 1 until SIZE - 1) {
        t[i] = ruleTest((s[i + 1] shl 2) or (s[i] shl 1) or s[i - 1].toInt())
    }
    for (i in 0 until SIZE) s[i] = t[i]
}

fun show(s: BitSet) {
    for (i in SIZE - 1 downTo 0) print(if (s[i]) "*" else " ")
    println()
}

fun main(args: Array<String>) {
    var state = BitSet(SIZE)
    state.set(LINES)
    println("Rule $RULE:")
    repeat(LINES) {
        show(state)
        evolve(state)
    }
}
