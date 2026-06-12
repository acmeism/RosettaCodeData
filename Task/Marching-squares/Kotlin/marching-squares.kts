object PerimeterDetection {
    // Direction constants
    private const val E = 0
    private const val N = 1
    private const val W = 2
    private const val S = 3

    // X generates coordinate pairs for a grid of given dimensions
    fun X(a: Int, b: Int): List<IntArray> {
        val c = mutableListOf<IntArray>()
        for (aa in 0..a) {
            for (bb in 0..b) {
                c.add(intArrayOf(aa, bb))
            }
        }
        return c
    }

    // any checks if any element in the array equals val
    fun any(arr: IntArray, value: Int): Boolean {
        return arr.contains(value)
    }

    // Data class to return multiple values from identifyPerimeter
    data class PerimeterResult(
        val x: Int,
        val y: Int,
        val path: String
    )

    // identifyPerimeter identifies the perimeter of a shape in a 2D matrix
    fun identifyPerimeter(data: Array<IntArray>): PerimeterResult {
        for (coords in X(data[0].size - 1, data.size - 1)) {
            val x = coords[0]
            val y = coords[1]

            if (y < data.size && x < data[0].size && data[y][x] != 0) {
                val path = StringBuilder()
                var cx = x
                var cy = y
                var d = 0
                var p = 0

                do {
                    var mask = 0

                    val vals = arrayOf(
                        intArrayOf(0, 0, 1),
                        intArrayOf(1, 0, 2),
                        intArrayOf(0, 1, 4),
                        intArrayOf(1, 1, 8)
                    )

                    for (value in vals) {
                        val dx = value[0]
                        val dy = value[1]
                        val b = value[2]
                        val mx = cx + dx
                        val my = cy + dy

                        if (mx > 0 && my > 0 && my - 1 < data.size &&
                            mx - 1 < data[0].size && data[my - 1][mx - 1] != 0) {
                            mask += b
                        }
                    }

                    if (any(intArrayOf(1, 5, 13), mask)) {
                        d = N
                    }
                    if (any(intArrayOf(2, 3, 7), mask)) {
                        d = E
                    }
                    if (any(intArrayOf(4, 12, 14), mask)) {
                        d = W
                    }
                    if (any(intArrayOf(8, 10, 11), mask)) {
                        d = S
                    }
                    if (mask == 6) {
                        d = if (p == N) W else E
                    }
                    if (mask == 9) {
                        d = if (p == E) N else S
                    }

                    val dirChars = charArrayOf('E', 'N', 'W', 'S')
                    path.append(dirChars[d])
                    p = d

                    val dxVals = intArrayOf(1, 0, -1, 0)
                    val dyVals = intArrayOf(0, -1, 0, 1)
                    cx += dxVals[d]
                    cy += dyVals[d]

                } while (!(cx == x && cy == y))

                return PerimeterResult(x, -y, path.toString())
            }
        }

        println("That did not work out...")
        kotlin.system.exitProcess(1)
    }
}

fun main() {
    val M = arrayOf(
        intArrayOf(0, 0, 0, 0, 0),
        intArrayOf(0, 0, 0, 0, 0),
        intArrayOf(0, 0, 1, 1, 0),
        intArrayOf(0, 0, 1, 1, 0),
        intArrayOf(0, 0, 0, 1, 0),
        intArrayOf(0, 0, 0, 0, 0)
    )

    val result = PerimeterDetection.identifyPerimeter(M)
    println("X: ${result.x}, Y: ${result.y}, Path: ${result.path}")
}
