// version 1.0.6

import java.util.Scanner

fun main(args: Array<String>) {
    val sc = Scanner(System.`in`)  // note: backticks required as 'in' is a Kotlin keyword
    val n = sc.nextInt()
    val x = IntArray(n)
    val y = IntArray(n)
    for (i in 0 until n) {
        x[i] = sc.nextInt()
        y[i] = sc.nextInt()
    }
    println()
    for (i in 0 until n) println(x[i] + y[i])
}
