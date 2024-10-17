// version 1.1.3

data class Solution(val x: Int, val y: Int, val z: Int)

fun Double.isIntegral(tolerance: Double = 0.0) =
    (this - Math.floor(this)) <= tolerance || (Math.ceil(this) - this) <= tolerance

fun pascal(a: Int, b: Int, mid: Int, top: Int): Solution {
    val yd = (top - 4 * (a + b)) / 7.0
    if (!yd.isIntegral(0.0001)) return Solution(0, 0, 0)
    val y = yd.toInt()
    val x = mid - 2 * a - y
    return Solution(x, y, y - x)
}

fun main(args: Array<String>) {
    val (x, y, z) = pascal(11, 4, 40, 151)
    if (x != 0)
        println("Solution is: x = $x, y = $y, z = $z")
    else
        println("There is no solutuon")
}
