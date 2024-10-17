// version 1.1.2

fun main(args: Array<String>) {
    val a = intArrayOf(1, 5, 8, 11, 15)
    println("Array contains : ${a.contentToString()}")
    val sum = a.sum()
    println("Sum is $sum")
    val product = a.fold(1) { acc, i -> acc * i }
    println("Product is $product")
}
