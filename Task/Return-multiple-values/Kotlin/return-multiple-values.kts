// version 1.0.6

/* implicitly returns a Pair<Int, Int>*/
fun minmax(ia: IntArray) = ia.min() to ia.max()

fun main(args: Array<String>) {
    val ia = intArrayOf(17, 88, 9, 33, 4, 987, -10, 2)
    val(min, max) = minmax(ia) // destructuring declaration
    println("The smallest number is $min")
    println("The largest  number is $max")
}
