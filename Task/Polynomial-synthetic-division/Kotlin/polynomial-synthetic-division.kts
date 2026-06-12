// version 1.1.2

fun extendedSyntheticDivision(dividend: IntArray, divisor: IntArray): Pair<IntArray, IntArray> {
    val out = dividend.copyOf()
    val normalizer = divisor[0]
    val separator = dividend.size - divisor.size + 1
    for (i in 0 until separator) {
        out[i] /= normalizer
        val coef = out[i]
        if (coef != 0) {
            for (j in 1 until divisor.size) out[i + j] += -divisor[j] * coef
        }
    }
    return out.copyOfRange(0, separator) to out.copyOfRange(separator, out.size)
}

fun main(args: Array<String>) {
    println("POLYNOMIAL SYNTHETIC DIVISION")
    val n = intArrayOf(1, -12, 0, -42)
    val d = intArrayOf(1, -3)
    val (q, r) = extendedSyntheticDivision(n, d)
    print("${n.contentToString()} / ${d.contentToString()}  =  ")
    println("${q.contentToString()}, remainder ${r.contentToString()}")
    println()
    val n2 = intArrayOf(1, 0, 0, 0, -2)
    val d2 = intArrayOf(1, 1, 1, 1)
    val (q2, r2) = extendedSyntheticDivision(n2, d2)
    print("${n2.contentToString()} / ${d2.contentToString()}  =  ")
    println("${q2.contentToString()}, remainder ${r2.contentToString()}")
}
