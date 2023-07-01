import kotlin.math.round
import kotlin.math.pow

fun Collection<Double>.geometricMean() =
    if (isEmpty()) Double.NaN
    else (reduce { n1, n2 -> n1 * n2 }).pow(1.0 / size)

fun Collection<Double>.harmonicMean() =
    if (isEmpty() || contains(0.0)) Double.NaN
    else size / fold(0.0) { n1, n2 -> n1 + 1.0 / n2 }

fun Double.toFixed(len: Int = 6) =
    round(this * 10.0.pow(len)) / 10.0.pow(len)

fun main() {
    val list = listOf(1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0)
    val a = list.average()  // arithmetic mean
    val g = list.geometricMean()
    val h = list.harmonicMean()
    println("A = $a  G = ${g.toFixed()}  H = ${h.toFixed()}")
    println("A >= G is ${a >= g}, G >= H is ${g >= h}")
    require(g in h..a)
}
