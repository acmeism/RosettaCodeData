// version 1.1.2

fun biased(n: Int) = Math.random() < 1.0 / n

fun unbiased(n: Int): Boolean {
    var a: Boolean
    var b: Boolean
    do {
        a = biased(n)
        b = biased(n)
    }
    while (a == b)
    return a
}

fun main(args: Array<String>) {
    val m = 50_000
    val f = "%d: %2.2f%%  %2.2f%%"
    for (n in 3..6) {
        var c1 = 0
        var c2 = 0
        for (i in 0 until m) {
            if (biased(n)) c1++
            if (unbiased(n)) c2++
        }
        println(f.format(n, 100.0 * c1 / m, 100.0 * c2 / m))
    }
}
