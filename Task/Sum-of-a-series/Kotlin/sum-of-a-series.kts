// version 1.0.6

fun main(args: Array<String>) {
    val n = 1000
    val sum = (1..n).sumByDouble { 1.0 / (it * it) }
    println("Actual sum is $sum")
    println("zeta(2)    is ${Math.PI * Math.PI / 6.0}")
}
