import java.lang.Math.*

data class Complex(val r: Double, val i: Double) {
    override fun toString() = when {
        i == 0.0 -> r.toString()
        r == 0.0 -> i.toString() + 'i'
        else -> "$r + ${i}i"
    }
}

fun unity_roots(n: Number) = (1..n.toInt() - 1).map {
    val a = it * 2 * PI / n.toDouble()
    var r = cos(a); if (abs(r) < 1e-6) r = 0.0
    var i = sin(a); if (abs(i) < 1e-6) i = 0.0
    Complex(r, i)
}

fun main(args: Array<String>) {
    (1..4).forEach { println(listOf(1) + unity_roots(it)) }
    println(listOf(1) + unity_roots(5.0))
}
