// version 1.0.5-2

/** overload ++ operator to increment a numeric string */
operator fun String.inc(): String =
    try {
        val num = this.toInt()
        (num + 1).toString()
    }
    catch(e: NumberFormatException) {
        this  // return string unaltered
    }

fun main(args: Array<String>) {
    var ns = "12345"
    println(++ns)
    ns = "ghijk"  // not numeric, so won't be changed by increment operator
    println(++ns)
}
