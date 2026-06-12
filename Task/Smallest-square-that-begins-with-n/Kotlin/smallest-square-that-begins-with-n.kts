val squares = generateSequence(1) {it + 1}.map{it * it}

val startSquares = generateSequence(1) {it + 1}.map {
    num -> squares.dropWhile{!selectEq(it, num)}.first()
}

fun selectEq(sqr: Int, num: Int): Boolean {
    return when (sqr > num) {
        true -> selectEq(sqr / 10, num)
        else -> sqr == num
    }
}

fun main() {
    val limit = 50
    startSquares.take(limit).chunked(10)
        .forEach{
            println(it.map{"%5d".format(it)}.joinToString(" "))
        }
} // © 2026
