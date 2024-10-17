// Kotlin JS version 1.1.4-3

fun evalWithX(expr: String, a: Double, b: Double) {
    var x = a
    val atA = eval(expr)
    x = b
    val atB = eval(expr)
    return atB - atA
}

fun main(args: Array<String>) {
    println(evalWithX("Math.exp(x)", 0.0, 1.0))
}
