// version 1.0.6

/* clears console on Windows 10 */
fun cls() = ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor()

fun main(args: Array<String>) {
    val units = listOf("tochka", "liniya", "dyuim", "vershok", "piad", "fut",
                       "arshin", "sazhen", "versta", "milia",
                       "centimeter", "meter", "kilometer")
    val convs = arrayOf(0.0254f, 0.254f, 2.54f, 4.445f, 17.78f, 30.48f,
                        71.12f, 213.36f, 106680.0f, 746760.0f,
                        1.0f, 100.0f, 100000.0f)
    var unit: Int
    var value: Float
    var yn : String
    do {
        cls()
        println()
        for (i in 0 until units.size) println("${"%2d".format(i + 1)} ${units[i]}")
        println()
        do {
            print("Please choose a unit 1 to 13 : ")
            unit = try { readLine()!!.toInt() } catch (e: NumberFormatException) { 0 }
        }
        while (unit !in 1..13)
        unit--
        do {
            print("Now enter a value in that unit : ")
            value = try { readLine()!!.toFloat() } catch (e: NumberFormatException) { -1.0f }
        }
        while (value < 0.0f)
        println("\nThe equivalent in the remaining units is:\n")
        for (i in 0 until units.size) {
            if (i == unit) continue
            println(" ${units[i].padEnd(10)} : ${value * convs[unit] / convs[i]}")
        }
        println()
        do {
            print("Do another one y/n : ")
            yn = readLine()!!.toLowerCase()
        }
        while (yn != "y" && yn != "n")
    }
    while (yn == "y")
}
