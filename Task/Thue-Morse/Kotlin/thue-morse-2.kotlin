fun thueMorse(n: Int): String {
    val pair = "0" to "1"
    repeat(n) { pair = with(pair) { first + second to second + first } }
    return pair.first
}

fun main() {
    for (i in 0..6) println("$i : ${thueMorse(i)}")
}
