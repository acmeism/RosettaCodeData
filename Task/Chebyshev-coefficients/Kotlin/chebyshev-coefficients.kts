// version 1.1.2

typealias DFunc = (Double) -> Double

fun mapRange(x: Double, min: Double, max: Double, minTo: Double, maxTo:Double): Double {
    return (x - min) / (max - min) * (maxTo - minTo) + minTo
}

fun chebCoeffs(func: DFunc, n: Int, min: Double, max: Double): DoubleArray {
    val coeffs = DoubleArray(n)
    for (i in 0 until n) {
        val f = func(mapRange(Math.cos(Math.PI * (i + 0.5) / n), -1.0, 1.0, min, max)) * 2.0 / n
        for (j in 0 until n) coeffs[j] += f * Math.cos(Math.PI * j * (i + 0.5) / n)
    }
    return coeffs
}

fun chebApprox(x: Double, n: Int, min: Double, max: Double, coeffs: DoubleArray): Double {
    require(n >= 2 && coeffs.size >= 2)
    var a = 1.0
    var b = mapRange(x, min, max, -1.0, 1.0)
    var res = coeffs[0] / 2.0 + coeffs[1] * b
    val xx = 2 * b
    var i = 2
    while (i < n) {
        val c = xx * b - a
        res += coeffs[i] * c
        a = b
        b = c
        i++
    }
    return res
}

fun main(args: Array<String>) {
    val n = 10
    val min = 0.0
    val max = 1.0
    val coeffs = chebCoeffs(Math::cos, n, min, max)
    println("Coefficients:")
    for (coeff in coeffs) println("%+1.15g".format(coeff))
    println("\nApproximations:\n  x      func(x)     approx       diff")
    for (i in 0..20) {
        val x = mapRange(i.toDouble(), 0.0, 20.0, min, max)
        val f = Math.cos(x)
        val approx = chebApprox(x, n, min, max, coeffs)
        System.out.printf("%1.3f  %1.8f  %1.8f  % 4.1e\n", x, f, approx, approx - f)
    }
}
