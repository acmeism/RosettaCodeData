// version 1.1.2

import java.io.File

fun main(args: Array<String>) {
    val x = doubleArrayOf(1.0, 2.0, 3.0, 1e11)
    val y = doubleArrayOf(1.0, 1.4142135623730951, 1.7320508075688772, 316227.76601683791)
    val xp = 3
    val yp = 5
    val f = "%.${xp}g\t%.${yp}g\n"
    val writer = File("output.txt").writer()
    writer.use {
        for (i in 0 until x.size) {
            val s = f.format(x[i], y[i])
            writer.write(s)
        }
    }
}
