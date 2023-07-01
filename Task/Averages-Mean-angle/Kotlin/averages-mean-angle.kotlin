// version 1.0.5-2

fun meanAngle(angles: DoubleArray): Double {
    val sinSum = angles.sumByDouble {  Math.sin(it * Math.PI / 180.0) }
    val cosSum = angles.sumByDouble {  Math.cos(it * Math.PI / 180.0) }
    return Math.atan2(sinSum / angles.size, cosSum / angles.size) * 180.0 / Math.PI
}

fun main(args: Array<String>) {
    val angles1 = doubleArrayOf(350.0, 10.0)
    val angles2 = doubleArrayOf(90.0, 180.0, 270.0, 360.0)
    val angles3 = doubleArrayOf(10.0, 20.0, 30.0)
    val fmt  = "%.2f degrees" // format results to 2 decimal places
    println("Mean for angles 1 is ${fmt.format(meanAngle(angles1))}")
    println("Mean for angles 2 is ${fmt.format(meanAngle(angles2))}")
    println("Mean for angles 3 is ${fmt.format(meanAngle(angles3))}")
}
