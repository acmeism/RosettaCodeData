// version 1.1.3

const val MAX = 2200
const val MAX2 = MAX * MAX * 2

fun main(args: Array<String>) {
    val found = BooleanArray(MAX + 1)   // all false by default
    val a2b2  = BooleanArray(MAX2 + 1)  // ditto
    var s = 3

    for (a in 1..MAX) {
        val a2 = a * a
        for (b in a..MAX) a2b2[a2 + b * b] = true
    }

    for (c in 1..MAX) {
        var s1 = s
        s += 2
        var s2 = s
        for (d in (c + 1)..MAX) {
            if (a2b2[s1]) found[d] = true
            s1 += s2
            s2 += 2
        }
    }

    println("The values of d <= $MAX which can't be represented:")
    for (d in 1..MAX) if (!found[d]) print("$d ")
    println()
}
