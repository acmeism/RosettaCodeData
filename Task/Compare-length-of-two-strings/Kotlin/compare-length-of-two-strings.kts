fun main() {
    printTwoStrings("a short string", "a fairly long string")
    printStringsInDescendingLengthOrder(listOf("abcd", "123456789", "abcdef", "1234567"))
}

fun printTwoStrings(a: String, b: String) {
    val (shorter, longer) = if (a.length < b.length) Pair(a, b) else Pair(b, a)
    println("%3d: %s".format(longer.length, longer))
    println("%3d: %s".format(shorter.length, shorter))
}

fun printStringsInDescendingLengthOrder(strings: Collection<String>) {
    strings.sortedByDescending(String::length).forEach {
        println("%3d: %s".format(it.length, it))
    }
}
