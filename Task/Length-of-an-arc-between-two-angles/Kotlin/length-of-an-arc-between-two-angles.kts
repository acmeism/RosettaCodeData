import kotlin.math.PI
import kotlin.math.abs

fun arcLength(radius: Double, angle1: Double, angle2: Double): Double {
    return (360.0 - abs(angle2 - angle1)) * PI * radius / 180.0
}

fun main() {
    val al = arcLength(10.0, 10.0, 120.0)
    println("arc length: $al")
}
