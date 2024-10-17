// version 1.0.6

fun meanAngle(angles: DoubleArray): Double {
    val sinSum = angles.sumByDouble {  Math.sin(it * Math.PI / 180.0) }
    val cosSum = angles.sumByDouble {  Math.cos(it * Math.PI / 180.0) }
    return Math.atan2(sinSum / angles.size, cosSum / angles.size) * 180.0 / Math.PI
}

/* time string assumed to be in format "hh:mm:ss" */
fun timeToSecs(t: String): Int {
    val hours = t.slice(0..1).toInt()
    val mins  = t.slice(3..4).toInt()
    val secs  = t.slice(6..7).toInt()
    return 3600 * hours + 60 * mins + secs
}

/* 1 second of time = 360/(24 * 3600) = 1/240th degree */
fun timeToDegrees(t: String): Double = timeToSecs(t) / 240.0

fun degreesToTime(d: Double): String {
    var dd = d
    if (dd < 0.0) dd += 360.0
    var secs  = (dd * 240.0).toInt()
    val hours = secs / 3600
    var mins  = secs % 3600
    secs  = mins % 60
    mins /= 60
    return String.format("%2d:%2d:%2d", hours, mins, secs)
}

fun main(args: Array<String>) {
    val tm = arrayOf("23:00:17", "23:40:20", "00:12:45", "00:17:19")
    val angles = DoubleArray(4) { timeToDegrees(tm[it]) }
    val mean = meanAngle(angles)
    println("Average time is : ${degreesToTime(mean)}")
}
