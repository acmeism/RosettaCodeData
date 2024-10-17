// version 1.0.6

fun fibWord(n: Int): String {
    if (n < 1) throw IllegalArgumentException("Argument can't be less than 1")
    if (n == 1) return "1"
    val words = Array(n){ "" }
    words[0] = "1"
    words[1] = "0"
    for (i in 2 until n) words[i] = words[i - 1] + words[i - 2]
    return words[n - 1]
}

fun log2(d: Double) = Math.log(d) / Math.log(2.0)

fun shannon(s: String): Double {
    if (s.length <= 1) return 0.0
    val count0 = s.count { it == '0' }
    val count1 = s.length - count0
    val nn = s.length.toDouble()
    return -(count0 / nn * log2(count0 / nn) + count1 / nn * log2(count1 / nn))
}

fun main(args: Array<String>) {
    println("N    Length       Entropy             Word")
    println("--  --------  ------------------  ----------------------------------")
    for (i in 1..37) {
        val s = fibWord(i)
        print(String.format("%2d  %8d  %18.16f", i, s.length, shannon(s)))
        if (i < 10) println("  $s")
        else println()
    }
}
