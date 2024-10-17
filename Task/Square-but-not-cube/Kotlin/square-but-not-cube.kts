// Version 1.2.60

fun main(args: Array<String>) {
    var n = 1
    var count = 0
    while (count < 30) {
        val sq = n * n
        val cr = Math.cbrt(sq.toDouble()).toInt()
        if (cr * cr * cr != sq) {
            count++
            println(sq)
        }
        else {
            println("$sq is square and cube")
        }
        n++
    }
}
