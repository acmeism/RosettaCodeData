const val NMAX  = 20
const val TESTS = 1000000
val rand = java.util.Random()

fun avg(n: Int): Double {
    var sum = 0
    for (t in 0 until TESTS) {
        val v = BooleanArray(NMAX)
        var x = 0
        while (!v[x]) {
            v[x] = true
            sum++
            x = rand.nextInt(n)
        }
    }
    return sum.toDouble() / TESTS
}

fun ana(n: Int): Double {
    val nn = n.toDouble()
    var term = 1.0
    var sum = 1.0
    for (i in n - 1 downTo 1) {
        term *= i / nn
        sum += term
    }
    return sum
}

fun main(args: Array<String>) {
    println(" N    average    analytical    (error)")
    println("===  =========  ============  =========")
    for (n in 1..NMAX) {
        val a = avg(n)
        val b = ana(n)
        println(String.format("%3d   %6.4f   %10.4f      (%4.2f%%)", n, a, b, Math.abs(a - b) / b * 100.0))
    }
}
