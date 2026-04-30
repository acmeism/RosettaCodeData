// version 2.3.10

typealias Func = () -> Int

fun a(k: Int, x1: Func, x2: Func, x3: Func, x4: Func, x5: Func): Int {
    var kk = k
    fun b(): Int = a(--kk, ::b, x1, x2, x3, x4)
    return if (kk <= 0) x4() + x5() else b()
}

fun main() {
  println(" k  a")
  repeat(13) { k ->
    println("${"%2d".format(k)}: ${a(k, { 1 }, { -1 }, { -1 }, { 1 }, { 0 })}")
  }
}
