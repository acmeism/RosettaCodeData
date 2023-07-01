fun f(x: Int): Int = x * x

fun g(x: Int): Int = x + 2

fun <T, V, R> compose(f: (V) -> R,  g: (T) -> V): (T) -> R  = { f(g(it) }

fun main() {
   val x = 10
   println(compose(::f, ::g)(x))
}
