// version 1.0.6

fun repeat(n: Int, f: () -> Unit) {
    for (i in 1..n) {
        f()
        println(i)
    }
}

fun main(args: Array<String>) {
    repeat(5) { print("Example ") }
}
