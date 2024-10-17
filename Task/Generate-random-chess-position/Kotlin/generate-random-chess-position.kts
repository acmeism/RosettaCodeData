// version 1.2.0

import java.util.Random
import kotlin.math.abs

val rand = Random()

val grid = List(8) { CharArray(8) }

const val NUL = '\u0000'

fun createFen(): String {
    placeKings()
    placePieces("PPPPPPPP", true)
    placePieces("pppppppp", true)
    placePieces("RNBQBNR", false)
    placePieces("rnbqbnr", false)
    return toFen()
}

fun placeKings() {
    while (true) {
        val r1 = rand.nextInt(8)
        val c1 = rand.nextInt(8)
        val r2 = rand.nextInt(8)
        val c2 = rand.nextInt(8)
        if (r1 != r2 && abs(r1 - r2) > 1 && abs(c1 - c2) > 1) {
            grid[r1][c1] = 'K'
            grid[r2][c2] = 'k'
            return
        }
    }
}

fun placePieces(pieces: String, isPawn: Boolean) {
    val numToPlace = rand.nextInt(pieces.length)
    for (n in 0 until numToPlace) {
        var r: Int
        var c: Int
        do {
            r = rand.nextInt(8)
            c = rand.nextInt(8)
        }
        while (grid[r][c] != NUL || (isPawn && (r == 7 || r == 0)))
        grid[r][c] = pieces[n]
    }
}

fun toFen(): String {
    val fen = StringBuilder()
    var countEmpty = 0
    for (r in 0..7) {
        for (c in 0..7) {
            val ch = grid[r][c]
            print ("%2c ".format(if (ch == NUL) '.' else ch))
            if (ch == NUL) {
                countEmpty++
            }
            else {
                if (countEmpty > 0) {
                    fen.append(countEmpty)
                    countEmpty = 0
                }
                fen.append(ch)
            }
        }
        if (countEmpty > 0) {
            fen.append(countEmpty)
            countEmpty = 0
        }
        fen.append("/")
        println()
    }
    return fen.append(" w - - 0 1").toString()
}

fun main(args: Array<String>) {
    println(createFen())
}
