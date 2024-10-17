// version 1.1.3

fun main(args: Array<String>) {
    val r = java.util.Random()
    val points = Array(31) { CharArray(31) { ' ' } }
    var count = 0
    while (count < 100) {
        val x = r.nextInt(31) - 15
        val y = r.nextInt(31) - 15
        val h = x * x + y * y
        if (h in 100..225) {
            points[x + 15][y + 15] = 'o'
            count++
        }
    }
    for (i in 0..30) println(points[i].joinToString(""))
}
