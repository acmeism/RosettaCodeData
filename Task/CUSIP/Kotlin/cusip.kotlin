// version 1.1.0

fun isCusip(s: String): Boolean {
    if (s.length != 9) return false
    var sum = 0
    for (i in 0..7) {
        val c = s[i]
        var v = when (c) {
            in '0'..'9'  -> c.toInt() - 48
            in 'A'..'Z'  -> c.toInt() - 55  // lower case letters apparently invalid
            '*'          -> 36
            '@'          -> 37
            '#'          -> 38
            else         -> return false
        }
        if (i % 2 == 1) v *= 2  // check if odd as using 0-based indexing
        sum += v / 10 + v % 10
    }
    return s[8].toInt() - 48  == (10 - (sum % 10)) % 10
}

fun main(args: Array<String>) {
    val candidates = listOf(
        "037833100",
        "17275R102",
        "38259P508",
        "594918104",
        "68389X106",
        "68389X105"
    )
    for (candidate in candidates)
        println("$candidate -> ${if(isCusip(candidate)) "correct" else "incorrect"}")
}
