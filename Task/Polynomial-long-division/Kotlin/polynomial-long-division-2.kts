class Polynom(private vararg val factors: Double) {

    operator fun div(divisor: Polynom): Pair<Polynom, Polynom> {
        var curr = canonical().factors
        val right = divisor.canonical().factors

        val result = mutableListOf<Double>()
        for (base in curr.size - right.size downTo 0) {
            val res = curr.last() / right.last()
            result += res
            curr = curr.copyOfRange(0, curr.size - 1)
            for (i in 0 until right.size - 1)
                curr[base + i] -= res * right[i]
        }

        val quot = Polynom(*result.asReversed().toDoubleArray())
        val rem = Polynom(*curr).canonical()
        return Pair(quot, rem)
    }

    private fun canonical(): Polynom {
        if (factors.last() != 0.0) return this
        for (newLen in factors.size downTo 1)
            if (factors[newLen - 1] != 0.0)
                return Polynom(*factors.copyOfRange(0, newLen))
        return Polynom(factors[0])
    }

    override fun toString() = "Polynom(${factors.joinToString(" ")})"
}

fun main() {
    val num = Polynom(-42.0, 0.0, -12.0, 1.0)
    val den = Polynom(-3.0, 1.0, 0.0, 0.0)

    val (quot, rem) = num / den

    print("$num / $den = $quot remainder $rem")
}
