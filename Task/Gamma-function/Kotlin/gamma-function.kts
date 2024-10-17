// version 1.0.6

fun gammaStirling(x: Double): Double = Math.sqrt(2.0 * Math.PI / x) * Math.pow(x / Math.E, x)

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

fun main(args: Array<String>) {
    println(" x\tStirling\t\tLanczos\n")
    for (i in 1 .. 20) {
        val d = i / 10.0
        print("%4.2f\t".format(d))
        print("%17.15f\t".format(gammaStirling(d)))
        println("%17.15f".format(gammaLanczos(d)))
    }
}
