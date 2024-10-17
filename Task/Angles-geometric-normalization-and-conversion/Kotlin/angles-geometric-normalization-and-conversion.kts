import java.text.DecimalFormat as DF

const val DEGREE = 360.0
const val GRADIAN = 400.0
const val MIL = 6400.0
const val RADIAN = 2 * Math.PI

fun d2d(a: Double) = a % DEGREE
fun d2g(a: Double) = a * (GRADIAN / DEGREE)
fun d2m(a: Double) = a * (MIL / DEGREE)
fun d2r(a: Double) = a * (RADIAN / 360)
fun g2d(a: Double) = a * (DEGREE / GRADIAN)
fun g2g(a: Double) = a % GRADIAN
fun g2m(a: Double) = a * (MIL / GRADIAN)
fun g2r(a: Double) = a * (RADIAN / GRADIAN)
fun m2d(a: Double) = a * (DEGREE / MIL)
fun m2g(a: Double) = a * (GRADIAN / MIL)
fun m2m(a: Double) = a % MIL
fun m2r(a: Double) = a * (RADIAN / MIL)
fun r2d(a: Double) = a * (DEGREE / RADIAN)
fun r2g(a: Double) = a * (GRADIAN / RADIAN)
fun r2m(a: Double) = a * (MIL / RADIAN)
fun r2r(a: Double) = a % RADIAN

fun main() {
    val fa = DF("######0.000000")
    val fc = DF("###0.0000")
    println("                               degrees    gradiens        mils     radians")
    for (a in listOf(-2.0, -1.0, 0.0, 1.0, 2.0, 6.2831853, 16.0, 57.2957795, 359.0, 399.0, 6399.0, 1000000.0))
        for (units in listOf("degrees", "gradiens", "mils", "radians")) {
            val (d,g,m,r) = when (units) {
                "degrees" -> {
                    val d = d2d(a)
                    listOf(d, d2g(d), d2m(d), d2r(d))
                }
                "gradiens" -> {
                    val g = g2g(a)
                    listOf(g2d(g), g, g2m(g), g2r(g))
                }
                "mils" -> {
                    val m = m2m(a)
                    listOf(m2d(m), m2g(m), m, m2r(m))
                }
                "radians" -> {
                    val r = r2r(a)
                    listOf(r2d(r), r2g(r), r2m(r), r)
                }
                else -> emptyList()
            }

            println("%15s  %8s = %10s  %10s  %10s  %10s".format(fa.format(a), units, fc.format(d), fc.format(g), fc.format(m), fc.format(r)))
        }
}
