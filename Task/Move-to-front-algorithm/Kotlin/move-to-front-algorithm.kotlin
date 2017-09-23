// version 1.1.2

fun encode(s: String): IntArray {
    if (s.isEmpty()) return intArrayOf()
    val symbols = "abcdefghijklmnopqrstuvwxyz".toCharArray()
    val result = IntArray(s.length)
    for ((i, c) in s.withIndex()) {
        val index = symbols.indexOf(c)
        if (index == -1)
            throw IllegalArgumentException("$s contains a non-alphabetic character")
        result[i] = index
        if (index == 0) continue
        for (j in index - 1 downTo 0) symbols[j + 1] = symbols[j]
        symbols[0] = c
    }
    return result
}

fun decode(a: IntArray): String {
    if (a.isEmpty()) return ""
    val symbols = "abcdefghijklmnopqrstuvwxyz".toCharArray()
    val result = CharArray(a.size)
    for ((i, n) in a.withIndex()) {
        if (n !in 0..25)
            throw IllegalArgumentException("${a.contentToString()} contains an invalid number")
        result[i] = symbols[n]
        if (n == 0) continue
        for (j in n - 1 downTo 0) symbols[j + 1] = symbols[j]
        symbols[0] = result[i]
    }
    return result.joinToString("")
}

fun main(args: Array<String>) {
    val strings = arrayOf("broood", "bananaaa", "hiphophiphop")
    val encoded = Array<IntArray?>(strings.size) { null }
    for ((i, s) in strings.withIndex()) {
        encoded[i] = encode(s)
        println("${s.padEnd(12)} -> ${encoded[i]!!.contentToString()}")
    }
    println()
    val decoded = Array<String?>(encoded.size) { null }
    for ((i, a) in encoded.withIndex()) {
        decoded[i] = decode(a!!)
        print("${a.contentToString().padEnd(38)} -> ${decoded[i]!!.padEnd(12)}")
        println(" -> ${if (decoded[i] == strings[i]) "correct" else "incorrect"}")
    }
}
