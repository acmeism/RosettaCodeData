// version 1.2.0

import java.util.Random

val rand = Random(0) // using a seed to produce same output on each run

enum class Pattern { BLINKER, GLIDER, RANDOM }

class Field(val w: Int, val h: Int) {
    val s = List(h) { BooleanArray(w) }

    operator fun set(x: Int, y: Int, b: Boolean) {
        s[y][x] = b
    }

    fun next(x: Int, y: Int): Boolean {
        var on = 0
        for (i in -1..1) {
            for (j in -1..1) {
                if (state(x + i, y + j) && !(j == 0 && i == 0)) on++
            }
        }
        return on == 3 || (on == 2 && state(x, y))
    }

    fun state(x: Int, y: Int): Boolean {
        if ((x !in 0 until w) || (y !in 0 until h)) return false
        return s[y][x]
    }
}

class Life(val pattern: Pattern) {
    val w: Int
    val h: Int
    var a: Field
    var b: Field

    init {
        when (pattern) {
            Pattern.BLINKER -> {
                w = 3
                h = 3
                a = Field(w, h)
                b = Field(w, h)
                a[0, 1] = true
                a[1, 1] = true
                a[2, 1] = true
            }

            Pattern.GLIDER -> {
                w = 4
                h = 4
                a = Field(w, h)
                b = Field(w, h)
                a[1, 0] = true
                a[2, 1] = true
                for (i in 0..2) a[i, 2] = true
            }

            Pattern.RANDOM -> {
                w = 80
                h = 15
                a = Field(w, h)
                b = Field(w, h)
                for (i in 0 until w * h / 2) {
                    a[rand.nextInt(w), rand.nextInt(h)] = true
                }
            }
        }
    }

    fun step() {
        for (y in 0 until h) {
            for (x in 0 until w) {
                b[x, y] = a.next(x, y)
            }
        }
        val t = a
        a = b
        b = t
    }

    override fun toString(): String {
        val sb = StringBuilder()
        for (y in 0 until h) {
            for (x in 0 until w) {
                val c = if (a.state(x, y)) '#' else '.'
                sb.append(c)
            }
            sb.append('\n')
        }
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    val lives = listOf(
        Triple(Life(Pattern.BLINKER), 3, "BLINKER"),
        Triple(Life(Pattern.GLIDER), 4, "GLIDER"),
        Triple(Life(Pattern.RANDOM), 100, "RANDOM")
    )
    for ((game, gens, title) in lives) {
        println("$title:\n")
        repeat(gens + 1) {
            println("Generation: $it\n$game")
            Thread.sleep(30)
            game.step()
        }
        println()
    }
}
