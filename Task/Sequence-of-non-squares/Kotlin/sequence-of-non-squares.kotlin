// version 1.1

fun f(n: Int) = n + Math.floor(0.5 + Math.sqrt(n.toDouble())).toInt()

fun main(args: Array<String>) {
    println(" n   f")
    val squares = mutableListOf<Int>()
    for (n in 1 until 1000000) {
        val v1 = f(n)
        val v2 = Math.sqrt(v1.toDouble()).toInt()
        if (v1 == v2 * v2) squares.add(n)
        if (n < 23) println("${"%2d".format(n)} : $v1")
    }
    println()
    if (squares.size == 0) println("There are no squares for n less than one million")
    else println("Squares are generated for the following values of n: $squares")
}
