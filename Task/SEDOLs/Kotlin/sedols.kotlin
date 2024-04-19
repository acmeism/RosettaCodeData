val weights = arrayOf(1, 3, 1, 7, 3, 9, 1)
val validChars = (('0'..'9') + ('A'..'Z')).toSet() - "AEIOU".toSet()

fun sedol7(sedol6: String): String {
    require(sedol6.length == 6) { "Length of argument string must be 6" }
    require(sedol6.all { it in validChars }) { "Argument string contains an invalid character" }

    val sum = sedol6.map { it.digitToInt(36) }.zip(weights, Int::times).sum()
    val check = (-sum).mod(10)
    return sedol6 + ('0' + check)
}

fun main() {
    val sedol6s = listOf(
        "710889", "B0YBKJ", "406566", "B0YBLH", "228276", "B0YBKL",
        "557910", "B0YBKR", "585284", "B0YBKT", "B00030"
    )
    for (sedol6 in sedol6s)
        println("$sedol6 -> ${sedol7(sedol6)}")
}
