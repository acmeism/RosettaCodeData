import kotlin.math.ln
import kotlin.math.pow

fun main() {
    runTest(12, 1)
    runTest(12, 2)
    runTest(123, 45)
    runTest(123, 12345)
    runTest(123, 678910)
}

private fun runTest(l: Int, n: Int) {
//    System.out.printf("p(%d, %d) = %,d%n", l, n, p(l, n))
    println("p($l, $n) = %,d".format(p(l, n)))
}

fun p(l: Int, n: Int): Int {
    var m = n
    var test = 0
    val log = ln(2.0) / ln(10.0)
    var factor = 1
    var loop = l
    while (loop > 10) {
        factor *= 10
        loop /= 10
    }
    while (m > 0) {
        test++
        val value = (factor * 10.0.pow(test * log % 1)).toInt()
        if (value == l) {
            m--
        }
    }
    return test
}
