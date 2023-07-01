import java.lang.Long.parseLong
import java.lang.Long.toString

fun String.splitAt(idx: Int): Array<String> {
    val ans = arrayOf(substring(0, idx), substring(idx))
    if (ans.first() == "") ans[0] = "0" // parsing "" throws an exception
    return ans
}

fun Long.getKaprekarParts(sqrStr:  String, base: Int): Array<String>? {
    for (j in 0..sqrStr.length / 2) {
        val parts = sqrStr.splitAt(j)
        val (first, second) = parts.map { parseLong(it, base) }

        // if the right part is all zeroes, then it will be forever, so break
        if (second == 0L) return null
        if (first + second == this) return parts
    }
    return null
}

fun main(args: Array<String>) {
    val base = if (args.isNotEmpty()) args[0].toInt() else 10
    var count = 0
    val max = 1000000L
    for (i in 1..max) {
        val s = toString(i * i, base)
        val p = i.getKaprekarParts(s, base)
        if (p != null) {
            println("%6d\t%6s\t%12s\t%7s + %7s".format(i, toString(i, base), s, p[0], p[1]))
            count++
        }
    }
    println("$count Kaprekar numbers < $max (base 10) in base $base")
}
