// version 1.1.2

fun horner(coeffs: DoubleArray, x: Double): Double {
    var sum = 0.0
    for (i in coeffs.size - 1 downTo 0) sum = sum * x + coeffs[i]
    return sum
}

fun main(args: Array<String>) {
    val coeffs = doubleArrayOf(-19.0, 7.0, -4.0, 6.0)
    println(horner(coeffs, 3.0))
}
