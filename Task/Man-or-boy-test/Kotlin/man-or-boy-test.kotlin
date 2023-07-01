// version 1.1.3

typealias Func = () -> Int

fun a(k: Int, x1: Func, x2: Func, x3: Func, x4: Func, x5: Func): Int {
    var kk = k
    fun b(): Int = a(--kk, ::b, x1, x2, x3, x4)
    return if (kk <= 0) x4() + x5() else b()
}

fun main(args: Array<String>) {
    println(" k  a")
    for (k in 0..12) {
        println("${"%2d".format(k)}: ${a(k, { 1 }, { -1 }, { -1 }, { 1 }, { 0 })}")
    }
}
