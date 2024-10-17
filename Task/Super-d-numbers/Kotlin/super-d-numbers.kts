import java.math.BigInteger

fun superD(d: Int, max: Int) {
    val start = System.currentTimeMillis()
    var test = ""
    for (i in 0 until d) {
        test += d
    }

    var n = 0
    var i = 0
    println("First $max super-$d numbers:")
    while (n < max) {
        i++
        val value: Any = BigInteger.valueOf(d.toLong()) * BigInteger.valueOf(i.toLong()).pow(d)
        if (value.toString().contains(test)) {
            n++
            print("$i ")
        }
    }
    val end = System.currentTimeMillis()
    println("\nRun time ${end - start} ms\n")
}

fun main() {
    for (i in 2..9) {
        superD(i, 10)
    }
}
