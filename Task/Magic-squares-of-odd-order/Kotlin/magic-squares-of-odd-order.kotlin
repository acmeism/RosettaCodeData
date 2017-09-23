// version 1.0.6

fun f(n: Int, x: Int, y: Int) = (x + y * 2 + 1) % n

fun main(args: Array<String>) {
    var n: Int
    while (true) {
        print("Enter the order of the magic square : ")
        n = readLine()!!.toInt()
        if (n < 1 || n % 2 == 0) println("Must be odd and >= 1, try again")
        else break
    }
    println()
    for (i in 0 until n) {
        for (j in 0 until n) print("%4d".format(f(n, n - j - 1, i) * n + f(n, j, i) + 1))
        println()
    }
    println("\nThe magic constant is ${(n * n + 1) / 2 * n}")
}
