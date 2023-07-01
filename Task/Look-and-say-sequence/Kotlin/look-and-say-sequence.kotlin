// version 1.0.6

fun lookAndSay(s: String): String {
    val sb = StringBuilder()
    var digit = s[0]
    var count = 1
    for (i in 1 until s.length) {
        if (s[i] == digit)
            count++
        else {
            sb.append("$count$digit")
            digit = s[i]
            count = 1
        }
    }
    return sb.append("$count$digit").toString()
}

fun main(args: Array<String>) {
    var las = "1"
    for (i in 1..15) {
        println(las)
        las = lookAndSay(las)
    }
}
