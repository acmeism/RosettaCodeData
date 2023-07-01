// version 1.1.0
// compiled with flag -Xcoroutines=enable to suppress 'experimental' warning

import kotlin.coroutines.experimental.buildSequence

fun generatePowers(m: Int) =
    buildSequence {
        var n = 0
        val mm = m.toDouble()
        while (true) yield(Math.pow((n++).toDouble(), mm).toLong())
    }

fun generateNonCubicSquares(squares: Sequence<Long>, cubes: Sequence<Long>) =
    buildSequence {
        val iter2 = squares.iterator()
        val iter3 = cubes.iterator()
        var square = iter2.next()
        var cube = iter3.next()
        while (true) {
            if (square > cube) {
                cube = iter3.next()
                continue
            } else if (square < cube) {
                yield(square)
            }
            square = iter2.next()
        }
    }

fun main(args: Array<String>) {
    val squares = generatePowers(2)
    val cubes = generatePowers(3)
    val ncs = generateNonCubicSquares(squares, cubes)
    print("Non-cubic squares (21st to 30th) : ")
    ncs.drop(20).take(10).forEach { print("$it ") } // print 21st to 30th items
    println()
}
