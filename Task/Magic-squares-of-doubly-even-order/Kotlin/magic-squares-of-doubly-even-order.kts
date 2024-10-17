// version 1.1.0

fun magicSquareDoublyEven(n: Int): Array<IntArray> {
    if ( n < 4 || n % 4 != 0)
        throw IllegalArgumentException("Base must be a positive multiple of 4")

    // pattern of count-up vs count-down zones
    val bits = 0b1001_0110_0110_1001
    val size = n * n
    val mult = n / 4  // how many multiples of 4
    val result = Array(n) { IntArray(n) }
    var i = 0
    for (r in 0 until n)
        for (c in 0 until n) {
            val bitPos = c / mult + r / mult * 4
            result[r][c] =  if (bits and (1 shl bitPos) != 0) i + 1 else size - i
            i++
        }
    return result
}

fun main(args: Array<String>) {
    val n = 8
    for (ia in magicSquareDoublyEven(n)) {
        for (i in ia) print("%2d  ".format(i))
        println()
    }
    println("\nMagic constant ${(n * n + 1) * n / 2}")
}
