// version 1.0.6

fun f(n: Int): Int =
    when {
        n == 0 -> 1
        else   -> n - m(f(n - 1))
    }

fun m(n: Int): Int =
    when {
        n == 0 -> 0
        else   -> n - f(m(n - 1))
    }

fun main(args: Array<String>) {
    val n = 24
    print("n :")
    for (i in 0..n) print("%3d".format(i))
    println()
    println("-".repeat((n + 2) * 3))
    print("F :")
    for (i in 0..n) print("%3d".format(f(i)))
    println()
    print("M :")
    for (i in 0..n) print("%3d".format(m(i)))
    println()
}
