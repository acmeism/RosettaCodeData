// version 1.0.6

fun main(args: Array<String>) {
    intArrayOf(4, 5, 6).forEach lambda@ {
        if (it == 5) return@lambda
        println(it)
    }
    println()
    loop@ for (i in 0 .. 3) {
        for (j in 0 .. 3) {
            if (i + j == 4) continue@loop
            if (i + j == 5) break@loop
            println(i + j)
        }
    }
}
