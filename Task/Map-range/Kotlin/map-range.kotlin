// version 1.0.6

class FloatRange(override val start: Float, override val endInclusive: Float) : ClosedRange<Float>

fun mapRange(range1: FloatRange, range2: FloatRange, value: Float): Float {
    if (value !in range1) throw IllegalArgumentException("value is not within the first range")
    if (range1.endInclusive == range1.start) throw IllegalArgumentException("first range cannot be single-valued")
    return range2.start + (value - range1.start) * (range2.endInclusive - range2.start) / (range1.endInclusive - range1.start)
}

fun main(args: Array<String>) {
    for (i in 0..10) {
        val mappedValue = mapRange(FloatRange(0.0f, 10.0f), FloatRange(-1.0f, 0.0f), i.toFloat())
        println(String.format("%2d  maps to %+4.2f", i, mappedValue))
    }
}
