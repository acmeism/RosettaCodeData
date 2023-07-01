// version 1.1.2

class Kelvin(val degrees: Double) {
    fun toCelsius() = degrees - 273.15

    fun toFahreneit() = (degrees - 273.15) * 1.8 + 32.0

    fun toRankine() = (degrees - 273.15) * 1.8 + 32.0 + 459.67
}

fun main(args: Array<String>) {
    print("Enter the temperature in degrees Kelvin : ")
    val degrees = readLine()!!.toDouble()
    val k = Kelvin(degrees)
    val f = "% 1.2f"
    println()
    println("K  ${f.format(k.degrees)}\n")
    println("C  ${f.format(k.toCelsius())}\n")
    println("F  ${f.format(k.toFahreneit())}\n")
    println("R  ${f.format(k.toRankine())}")
}
