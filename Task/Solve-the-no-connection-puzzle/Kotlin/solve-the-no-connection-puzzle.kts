// version 1.2.0

import kotlin.math.abs

// Holes A=0, B=1, …, H=7
// With connections:
const val conn = """
       A   B
      /|\ /|\
     / | X | \
    /  |/ \|  \
   C - D - E - F
    \  |\ /|  /
     \ | X | /
      \|/ \|/
       G   H
"""

val connections = listOf(
    0 to 2, 0 to 3, 0 to 4,   // A to C, D, E
    1 to 3, 1 to 4, 1 to 5,   // B to D, E, F
    6 to 2, 6 to 3, 6 to 4,   // G to C, D, E
    7 to 3, 7 to 4, 7 to 5,   // H to D, E, F
    2 to 3, 3 to 4, 4 to 5    // C-D, D-E, E-F
)

// 'isValid' checks if the pegs are a valid solution.
// If the absolute difference between any pair of connected pegs is
// greater than one it is a valid solution.
fun isValid(pegs: IntArray): Boolean {
   for ((a, b) in connections) {
       if (abs(pegs[a] - pegs[b]) <= 1) return false
   }
   return true
}

fun swap(pegs: IntArray, i: Int, j: Int) {
    val tmp = pegs[i]
    pegs[i] = pegs[j]
    pegs[j] = tmp
}

// 'solve' is a simple recursive brute force solver,
// it stops at the first found solution.
// It returns the solution, the number of positions tested,
// and the number of pegs swapped.

fun solve(): Triple<IntArray, Int, Int> {
    val pegs = IntArray(8) { it + 1 }
    var tests = 0
    var swaps = 0

    fun recurse(i: Int): Boolean {
        if (i >= pegs.size - 1) {
            tests++
            return isValid(pegs)
        }
        // Try each remaining peg from pegs[i] onwards
        for (j in i until pegs.size) {
            swaps++
            swap(pegs, i, j)
            if (recurse(i + 1)) return true
            swap(pegs, i, j)
        }
        return false
    }

    recurse(0)
    return Triple(pegs, tests, swaps)
}

fun pegsAsString(pegs: IntArray): String {
    val ca = conn.toCharArray()
    for ((i, c) in ca.withIndex()) {
        if (c in 'A'..'H') ca[i] = '0' + pegs[c - 'A']
    }
    return String(ca)
}

fun main(args: Array<String>) {
    val (p, tests, swaps) = solve()
    println(pegsAsString(p))
    println("Tested $tests positions and did $swaps swaps.")
}
