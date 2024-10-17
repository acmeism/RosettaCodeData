// version 1.1.51

typealias Func = (Double) -> Double

fun gammaLanczos(x: Double): Double {
    var xx = x
    val p = doubleArrayOf(
        0.99999999999980993,
      676.5203681218851,
    -1259.1392167224028,
      771.32342877765313,
     -176.61502916214059,
       12.507343278686905,
       -0.13857109526572012,
        9.9843695780195716e-6,
        1.5056327351493116e-7
    )
    val g = 7
    if (xx < 0.5) return Math.PI / (Math.sin(Math.PI * xx) * gammaLanczos(1.0 - xx))
    xx--
    var a = p[0]
    val t = xx + g + 0.5
    for (i in 1 until p.size) a += p[i] / (xx + i)
    return Math.sqrt(2.0 * Math.PI) * Math.pow(t, xx + 0.5) * Math.exp(-t) * a
}

fun integrate(a: Double, b: Double, n: Int, f: Func): Double {
    val h = (b - a) / n
    var sum = 0.0
    for (i in 0 until n) {
        val x = a + i * h
        sum += (f(x) + 4.0 * f(x + h / 2.0) + f(x + h)) / 6.0
    }
    return sum * h
}

fun gammaIncompleteQ(a: Double, x: Double): Double {
    val aa1 = a - 1.0
    fun f0(t: Double) = Math.pow(t, aa1) * Math.exp(-t)
    val h = 1.5e-2
    var y = aa1
    while ((f0(y) * (x - y) > 2.0e-8) && y < x) y += 0.4
    if (y > x) y = x
    return 1.0 - integrate(0.0, y, (y / h).toInt(), ::f0) / gammaLanczos(a)
}

fun chi2UniformDistance(ds: DoubleArray): Double {
    val expected = ds.average()
    val sum = ds.map { val x = it - expected; x * x }.sum()
    return sum / expected
}

fun chi2Probability(dof: Int, distance: Double) =
    gammaIncompleteQ(0.5 * dof, 0.5 * distance)

fun chiIsUniform(ds: DoubleArray, significance: Double):Boolean {
    val dof = ds.size - 1
    val dist = chi2UniformDistance(ds)
    return chi2Probability(dof, dist) > significance
}

fun main(args: Array<String>) {
    val dsets = listOf(
        doubleArrayOf(199809.0, 200665.0, 199607.0, 200270.0, 199649.0),
        doubleArrayOf(522573.0, 244456.0, 139979.0,  71531.0,  21461.0)
    )
    for (ds in dsets) {
        println("Dataset: ${ds.asList()}")
        val dist = chi2UniformDistance(ds)
        val dof = ds.size - 1
        print("DOF: $dof  Distance: ${"%.4f".format(dist)}")
        val prob = chi2Probability(dof, dist)
        print("  Probability: ${"%.6f".format(prob)}")
        val uniform = if (chiIsUniform(ds, 0.05)) "Yes" else "No"
        println("  Uniform? $uniform\n")
    }
}
