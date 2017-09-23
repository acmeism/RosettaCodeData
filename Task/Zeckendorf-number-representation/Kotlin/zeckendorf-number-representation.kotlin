// version 1.0.6

const val LIMIT = 46  // to stay within range of signed 32 bit integer
val fibs = fibonacci(LIMIT)

fun fibonacci(n: Int): IntArray {
    if (n !in 2..LIMIT) throw IllegalArgumentException("n must be between 2 and $LIMIT")
    val fibs = IntArray(n)
    fibs[0] = 1
    fibs[1] = 1
    for (i in 2 until n) fibs[i] = fibs[i - 1] + fibs[i - 2]
    return fibs
}

fun zeckendorf(n: Int): String {
    if (n < 0) throw IllegalArgumentException("n must be non-negative")
    if (n < 2) return n.toString()
    var lastFibIndex = 1
    for (i in 2..LIMIT)
        if (fibs[i] > n) {
            lastFibIndex = i - 1
            break
        }
    var nn = n - fibs[lastFibIndex--]
    val zr = StringBuilder("1")
    for (i in lastFibIndex downTo 1)
        if (fibs[i] <= nn) {
            zr.append('1')
            nn -= fibs[i]
        } else {
            zr.append('0')
        }
    return zr.toString()
}

fun main(args: Array<String>) {
    println(" n   z")
    for (i in 0..20) println("${"%2d".format(i)} : ${zeckendorf(i)}")
}
