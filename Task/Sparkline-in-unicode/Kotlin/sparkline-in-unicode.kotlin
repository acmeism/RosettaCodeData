internal const val bars = "▁▂▃▄▅▆▇█"
internal const val n = bars.length - 1

fun <T: Number> Iterable<T>.toSparkline(): String {
    var min = Double.MAX_VALUE
    var max = Double.MIN_VALUE
    val doubles = map { it.toDouble() }
    doubles.forEach { i -> when { i < min -> min = i; i > max -> max = i } }
    val range = max - min
    return doubles.fold("") { line, d -> line + bars[Math.ceil((d - min) / range * n).toInt()] }
}

fun String.toSparkline() = replace(",", "").split(" ").map { it.toFloat() }.toSparkline()

fun main(args: Array<String>) {
    val s1 = "1 2 3 4 5 6 7 8 7 6 5 4 3 2 1"
    println(s1)
    println(s1.toSparkline())
    val s2 = "1.5, 0.5 3.5, 2.5 5.5, 4.5 7.5, 6.5"
    println(s2)
    println(s2.toSparkline())
}
