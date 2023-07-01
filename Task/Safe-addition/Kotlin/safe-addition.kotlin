// version 1.1.2

fun stepDown(d: Double) = Math.nextAfter(d, Double.NEGATIVE_INFINITY)

fun stepUp(d: Double) = Math.nextUp(d)

fun safeAdd(a: Double, b: Double) = stepDown(a + b).rangeTo(stepUp(a + b))

fun main(args: Array<String>) {
    val a = 1.2
    val b = 0.03
    println("($a + $b) is in the range ${safeAdd(a, b)}")
}
