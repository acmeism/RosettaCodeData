// version 1.1.2

fun main(args: Array<String>) {
    val limit = (1 shl 20) + 1
    val a = IntArray(limit)
    a[1] = 1
    a[2] = 1
    for (n in 3 until limit) {
        val p = a[n - 1]
        a[n] = a[p] + a[n - p]
    }

    println("     Range          Maximum")
    println("----------------   --------")
    var pow2 = 1
    var p = 1
    var max = a[1].toDouble()
    for (n in 2 until limit) {
        val r = a[n].toDouble() / n
        if (r > max) max = r
        if (n == pow2 * 2) {
            println("2 ^ ${"%2d".format(p - 1)} to 2 ^ ${"%2d".format(p)}   ${"%f".format(max)}")
            pow2 *= 2
            p++
            max = r
        }
    }

    var prize = 0
    for (n in limit - 1 downTo 1) {
        if (a[n].toDouble() / n >= 0.55) {
            prize = n
            break
        }
    }
    println("\nMallows' number = $prize")
}
