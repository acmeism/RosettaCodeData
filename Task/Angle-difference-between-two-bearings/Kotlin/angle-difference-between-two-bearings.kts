// version 1.1.2

class Angle(d: Double) {
    val value = when {
       d in -180.0 .. 180.0 -> d
       d > 180.0            -> (d - 180.0) % 360.0 - 180.0
       else                 -> (d + 180.0) % 360.0 + 180.0
    }

    operator fun minus(other: Angle) = Angle(this.value - other.value)
}

fun main(args: Array<String>) {
    val anglePairs = arrayOf(
         20.0 to 45.0,
        -45.0 to 45.0,
        -85.0 to 90.0,
        -95.0 to 90.0,
        -45.0 to 125.0,
        -45.0 to 145.0,
         29.4803 to -88.6381,
        -78.3251 to -159.036,
        -70099.74233810938 to 29840.67437876723,
        -165313.6666297357 to 33693.9894517456,
         1174.8380510598456 to -154146.66490124757,
         60175.77306795546 to 42213.07192354373
    )
    println("       b1            b2           diff")
    val f = "% 12.4f  % 12.4f  % 12.4f"
    for (ap in anglePairs) {
        val diff = Angle(ap.second) - Angle(ap.first)
        println(f.format(ap.first, ap.second, diff.value))
    }
}
