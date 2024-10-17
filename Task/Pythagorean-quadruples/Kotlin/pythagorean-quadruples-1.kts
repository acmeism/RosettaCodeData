// version 1.1.3

const val MAX = 2200
const val MAX2 = MAX * MAX - 1

fun main(args: Array<String>) {
    val found = BooleanArray(MAX + 1)       // all false by default
    val p2 = IntArray(MAX + 1) { it * it }  // pre-compute squares

    // compute all possible positive values of d * d - c * c and map them back to d
    val dc = mutableMapOf<Int, MutableList<Int>>()
    for (d in 1..MAX) {
        for (c in 1 until d) {
            val diff = p2[d] - p2[c]
            val v = dc[diff]
            if (v == null)
                dc.put(diff, mutableListOf(d))
            else if (d !in v)
                v.add(d)
        }
    }

    for (a in 1..MAX) {
        for (b in 1..a) {
            if ((a and 1) != 0 && (b and 1) != 0) continue
            val sum = p2[a] + p2[b]
            if (sum > MAX2) continue
            val v = dc[sum]
            if (v != null) v.forEach { found[it] = true }
        }
    }
    println("The values of d <= $MAX which can't be represented:")
    for (i in 1..MAX) if (!found[i]) print("$i ")
    println()
}
