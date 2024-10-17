// version 1.0.6

fun repString(s: String): MutableList<String> {
    val reps = mutableListOf<String>()
    if (s.length < 2) return reps
    for (c in s) if (c != '0' && c != '1') throw IllegalArgumentException("Not a binary string")
    for (len in 1..s.length / 2) {
        val t = s.take(len)
        val n = s.length / len
        val r = s.length % len
        val u = t.repeat(n) + t.take(r)
        if (u == s) reps.add(t)
    }
    return reps
}

fun main(args: Array<String>) {
    val strings = listOf(
        "1001110011",
        "1110111011",
        "0010010010",
        "1010101010",
        "1111111111",
        "0100101101",
        "0100100",
        "101",
        "11",
        "00",
        "1"
    )
    println("The (longest) rep-strings are:\n")
    for (s in strings) {
        val reps = repString(s)
        val size = reps.size
        println("${s.padStart(10)} -> ${if (size > 0) reps[size - 1] else "Not a rep-string"}")
    }
}
