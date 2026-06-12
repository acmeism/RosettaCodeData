// version 1.1.2

fun kahanSum(vararg fa: Float): Float {
    var sum = 0.0f
    var c = 0.0f
    for (f in fa) {
        val y = f - c
        val t = sum + y
        c = (t - sum) - y
        sum = t
    }
    return sum
}

fun epsilon(): Float {
    var eps = 1.0f
    while (1.0f + eps != 1.0f) eps /= 2.0f
    return eps
}

fun main(args: Array<String>) {
    val a = 1.0f
    val b = epsilon()
    val c = -b
    println("Epsilon      = $b")
    println("(a + b) + c  = ${(a + b) + c}")
    println("Kahan sum    = ${kahanSum(a, b, c)}")
}
