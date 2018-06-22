// version 1.1.51

typealias IAE = IllegalArgumentException

data class Solution(val quotient: DoubleArray, val remainder: DoubleArray)

fun polyDegree(p: DoubleArray): Int {
    for (i in p.size - 1 downTo 0) {
        if (p[i] != 0.0) return i
    }
    return Int.MIN_VALUE
}

fun polyShiftRight(p: DoubleArray, places: Int): DoubleArray {
    if (places <= 0) return p
    val pd = polyDegree(p)
    if (pd + places >= p.size) {
        throw IAE("The number of places to be shifted is too large")
    }
    val d = p.copyOf()
    for (i in pd downTo 0) {
        d[i + places] = d[i]
        d[i] = 0.0
    }
    return d
}

fun polyMultiply(p: DoubleArray, m: Double) {
    for (i in 0 until p.size) p[i] *= m
}

fun polySubtract(p: DoubleArray, s: DoubleArray) {
    for (i in 0 until p.size) p[i] -= s[i]
}

fun polyLongDiv(n: DoubleArray, d: DoubleArray): Solution {
    if (n.size != d.size) {
        throw IAE("Numerator and denominator vectors must have the same size")
    }
    var nd = polyDegree(n)
    val dd = polyDegree(d)
    if (dd < 0) {
        throw IAE("Divisor must have at least one one-zero coefficient")
    }
    if (nd < dd) {
        throw IAE("The degree of the divisor cannot exceed that of the numerator")
    }
    val n2 = n.copyOf()
    val q = DoubleArray(n.size)  // all elements zero by default
    while (nd >= dd) {
        val d2 = polyShiftRight(d, nd - dd)
        q[nd - dd] = n2[nd] / d2[nd]
        polyMultiply(d2, q[nd - dd])
        polySubtract(n2, d2)
        nd = polyDegree(n2)
    }
    return Solution(q, n2)
}

fun polyShow(p: DoubleArray) {
    val pd = polyDegree(p)
    for (i in pd downTo 0) {
        val coeff = p[i]
        if (coeff == 0.0) continue
        print (when {
            coeff ==  1.0  -> if (i < pd) " + " else ""
            coeff == -1.0  -> if (i < pd) " - " else "-"
            coeff <   0.0  -> if (i < pd) " - ${-coeff}" else "$coeff"
            else           -> if (i < pd) " + $coeff" else "$coeff"
        })
        if (i > 1) print("x^$i")
        else if (i == 1) print("x")
    }
    println()
}

fun main(args: Array<String>) {
    val n = doubleArrayOf(-42.0, 0.0, -12.0, 1.0)
    val d = doubleArrayOf( -3.0, 1.0,   0.0, 0.0)
    print("Numerator   : ")
    polyShow(n)
    print("Denominator : ")
    polyShow(d)
    println("-------------------------------------")
    val (q, r) = polyLongDiv(n, d)
    print("Quotient    : ")
    polyShow(q)
    print("Remainder   : ")
    polyShow(r)
}
