import kotlin.math.*

fun compose(f: (Double) -> Double,  g: (Double) -> Double ): (Double) -> Double  = { f(g(it)) }

fun cube(d: Double) = d * d * d

fun main() {
    val listA = listOf(::sin, ::cos, ::cube)
    val listB = listOf(::asin, ::acos, ::cbrt)
    val x = 0.5
    for (i in 0..2) println(compose(listA[i], listB[i])(x))
}
