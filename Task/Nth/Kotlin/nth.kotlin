fun Int.ordinalAbbrev() =
        if (this % 100 / 10 == 1) "th"
        else when (this % 10) { 1 -> "st" 2 -> "nd" 3 -> "rd" else -> "th" }

fun IntRange.ordinalAbbrev() = map { "$it" + it.ordinalAbbrev() }.joinToString(" ")

fun main(args: Array<String>) {
    listOf((0..25), (250..265), (1000..1025)).forEach { println(it.ordinalAbbrev()) }
}
