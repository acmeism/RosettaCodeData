import kotlin.math.abs
import kotlin.math.pow

private infix fun Int.`^`(exponent: Int): Int = toDouble().pow(exponent).toInt()

fun main() {
    var prod = 1
    var sum = 0
    val x = 5
    val y = -5
    val z = -2
    val one = 1
    val three = 3
    val seven = 7
    val p = 11 `^` x

    for (j in sequenceOf(
        -three..(3 `^` 3) step three,
        -seven..seven step x,
        555..550-y,
        22 downTo -28 step three,
        1927..1939,
        x downTo y step -z,
        p..p + one
    ).flatten()) {
        sum += abs(j)
        if (abs(prod) < (2 `^` 27) && j != 0) prod *= j
    }
    System.out.printf("sum  = % ,d\n", sum)
    System.out.printf("prod = % ,d\n", prod)
}
