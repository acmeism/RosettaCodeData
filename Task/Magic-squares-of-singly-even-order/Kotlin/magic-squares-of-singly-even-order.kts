// version 1.0.6

fun magicSquareOdd(n: Int): Array<IntArray> {
    if (n < 3 || n % 2 == 0)
         throw IllegalArgumentException("Base must be odd and > 2")

    var value = 0
    val gridSize = n * n
    var c = n / 2
    var r = 0
    val result = Array(n) { IntArray(n) }
    while (++value <= gridSize) {
        result[r][c] = value
        if (r == 0) {
            if (c == n - 1) r++
            else {
                r = n - 1
                c++
            }
        }
        else if (c == n - 1) {
            r--
            c = 0
        }
        else if (result[r - 1][c + 1] == 0) {
            r--
            c++
        }
        else r++
    }
    return result
}

fun magicSquareSinglyEven(n: Int): Array<IntArray> {
    if (n < 6 || (n - 2) % 4 != 0)
        throw IllegalArgumentException("Base must be a positive multiple of 4 plus 2")

    val size = n * n
    val halfN = n / 2
    val subSquareSize = size / 4
    val subSquare = magicSquareOdd(halfN)
    val quadrantFactors = intArrayOf(0, 2, 3, 1)
    val result = Array(n) { IntArray(n) }
    for (r in 0 until n)
        for (c in 0 until n) {
            val quadrant = r / halfN * 2  + c / halfN
            result[r][c] = subSquare[r % halfN][c % halfN]
            result[r][c] += quadrantFactors[quadrant] * subSquareSize
        }
    val nColsLeft = halfN / 2
    val nColsRight = nColsLeft - 1
    for (r in 0 until halfN)
        for (c in 0 until n)
            if (c < nColsLeft || c >= n - nColsRight || (c == nColsLeft && r == nColsLeft)) {
                if (c == 0 && r == nColsLeft) continue
                val tmp = result[r][c]
                result[r][c] = result[r + halfN][c]
                result[r + halfN][c] = tmp
            }
    return result
}

fun main(args: Array<String>) {
    val n = 6
    for (ia in magicSquareSinglyEven(n)) {
        for (i in ia) print("%2d  ".format(i))
        println()
    }
    println("\nMagic constant ${(n * n + 1) * n / 2}")
}
