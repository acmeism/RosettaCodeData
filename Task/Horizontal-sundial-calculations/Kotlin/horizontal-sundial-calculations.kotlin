import java.lang.Math.atan2
import java.lang.Math.cos
import java.lang.Math.sin
import java.lang.Math.toDegrees
import java.lang.Math.toRadians

// version 1.1.4

fun main(args: Array<String>) {
    println("Please enter the following in degrees:")
    print("  Latitude       : ")
    val lat = readLine()!!.toDouble()
    print("  Longitude      : ")
    val lng = readLine()!!.toDouble()
    print("  Legal Meridian : ")
    val mer = readLine()!!.toDouble()

    val slat = sin(toRadians(lat))
    val diff = lng - mer
    println("\nSine of latitude     = ${"%.6f".format(slat)}")
    println("Longitude - Meridian = ${"%.3f".format(diff)}\n")
    println("Hour   Sun Hour Angle  Dial Hour Line Angle")
    println("-----  --------------  --------------------")
    println("              °               °")
    for (h in -6..6) {
        var hr = h + 12
        val am = if (hr < 12) "AM" else "PM"
        if (hr > 12) hr -= 12
        val sha = 15.0 * h - diff
        val dhla = toDegrees(atan2(slat * sin(toRadians(sha)), cos(toRadians(sha))))
        println("%2d %s      %+7.3f         %+7.3f".format(hr, am, sha, dhla))
    }
}
