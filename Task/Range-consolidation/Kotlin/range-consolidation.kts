fun <T> consolidate(ranges: Iterable<ClosedRange<T>>): List<ClosedRange<T>> where T : Comparable<T>
{
    return ranges
        .sortedWith(compareBy({ it.start }, { it.endInclusive }))
        .asReversed()
        .fold(mutableListOf<ClosedRange<T>>()) {
            consolidatedRanges, range ->
            if (consolidatedRanges.isEmpty())
            {
                consolidatedRanges.add(range)
            }
            // Keep in mind the reverse-sorting applied above:
            // If the end of the current-range is higher, than it must start at a lower value,
            else if (range.endInclusive >= consolidatedRanges[0].endInclusive)
            {
                consolidatedRanges[0] = range
            }
            else if (range.endInclusive >= consolidatedRanges[0].start)
            {
                consolidatedRanges[0] = range.start .. consolidatedRanges[0].endInclusive
            }
            else
            {
                consolidatedRanges.add(0, range)
            }

            return@fold consolidatedRanges
        }
        .toList()
}

// What a bummer! Kotlin's range syntax (a..b) doesn't meet the task requirements when b < b,
// and on the other hand, the syntax for constructing lists, arrays and pairs isn't close enough
// to the range notation. Instead then, here's a *very* naive parser. Don't take it seriously.
val rangeRegex = Regex("""\[(.+),(.+)\]""")
fun parseDoubleRange(rangeStr: String): ClosedFloatingPointRange<Double> {
    val parts = rangeRegex
        .matchEntire(rangeStr)
        ?.groupValues
        ?.drop(1)
        ?.map { it.toDouble() }
        ?.sorted()
    if (parts == null) throw IllegalArgumentException("Unable to parse range $rangeStr")
    return parts[0] .. parts[1]
}

fun serializeRange(range: ClosedRange<*>) = "[${range.start}, ${range.endInclusive}]"

// See above. In practice you'd probably use consolidate directly
fun consolidateDoubleRanges(rangeStrings: Iterable<String>): List<String>
{
    return consolidate(rangeStrings.asSequence().map(::parseDoubleRange).toList()).map(::serializeRange)
}


fun main() {
    val inputRanges = listOf(
        listOf("[1.1, 2.2]"),
        listOf("[6.1, 7.2]", "[7.2, 8.3]"),
        listOf("[4, 3]", "[2, 1]"),
        listOf("[4, 3]", "[2, 1]", "[-1, -2]", "[3.9, 10]"),
        listOf("[1, 3]", "[-6, -1]", "[-4, -5]", "[8, 2]", "[-6, -6]")
    )

    inputRanges.associateBy(Any::toString, ::consolidateDoubleRanges).forEach({ println("${it.key} => ${it.value}") })
}
