fun compoundDuration(n: Int): String {
    if (n < 0) return "" // task doesn't ask for negative integers to be converted
    if (n == 0) return "0 sec"
    val weeks  : Int
    val days   : Int
    val hours  : Int
    val minutes: Int
    val seconds: Int
    var divisor: Int = 7 * 24 * 60 * 60
    var rem    : Int
    var result = ""

    weeks = n / divisor
    rem   = n % divisor
    divisor /= 7
    days  = rem / divisor
    rem  %= divisor
    divisor /= 24
    hours = rem / divisor
    rem  %= divisor
    divisor /= 60
    minutes = rem / divisor
    seconds = rem % divisor

    if (weeks > 0)   result += "$weeks wk, "
    if (days > 0)    result += "$days d, "
    if (hours > 0)   result += "$hours hr, "
    if (minutes > 0) result += "$minutes min, "
    if (seconds > 0)
        result += "$seconds sec"
    else
        result = result.substring(0, result.length - 2)
    return result
}

fun main(args: Array<String>) {
    val durations = intArrayOf(0, 7, 84, 7259, 86400, 6000000)
    durations.forEach { println("$it\t-> ${compoundDuration(it)}") }
}
