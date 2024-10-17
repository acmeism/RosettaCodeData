fun main(args: Array<String>) {
    val a = intArrayOf(1, 2, 3, 4, 5)
    println("Array       : ${a.joinToString(", ")}")
    println("Sum         : ${a.reduce { x, y -> x + y }}")
    println("Difference  : ${a.reduce { x, y -> x - y }}")
    println("Product     : ${a.reduce { x, y -> x * y }}")
    println("Minimum     : ${a.reduce { x, y -> if (x < y) x else y }}")
    println("Maximum     : ${a.reduce { x, y -> if (x > y) x else y }}")
}
