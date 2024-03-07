import java.util.*

object JordanPolyaNumbers {
    private val jordanPolyaSet = TreeSet<Long>()
    private val decompositions = HashMap<Long, TreeMap<Int, Int>>()

    @JvmStatic
    fun main(aArgs: Array<String>) {
        createJordanPolya()

        val belowHundredMillion = jordanPolyaSet.floor(100_000_000L)
        val jordanPolya = ArrayList(jordanPolyaSet)

        println("The first 50 Jordan-Polya numbers:")
        for (i in 0 until 50) {
            print(String.format("%5s%s", jordanPolya[i], if (i % 10 == 9) "\n" else ""))
        }
        println()

        println("The largest Jordan-Polya number less than 100 million: $belowHundredMillion")
        println()

        for (i in listOf(800, 1050, 1800, 2800, 3800)) {
            println("The $i th Jordan-Polya number is: ${jordanPolya[i - 1]} = ${toString(decompositions[jordanPolya[i - 1]]!!)}")
        }
    }

    private fun createJordanPolya() {
        jordanPolyaSet.add(1L)
        val nextSet = TreeSet<Long>()
        decompositions[1L] = TreeMap()
        var factorial = 1L

        for (multiplier in 2..20) {
            factorial *= multiplier
            val iterator = jordanPolyaSet.iterator()
            while (iterator.hasNext()) {
                var number = iterator.next()
                while (number <= Long.MAX_VALUE / factorial) {
                    val original = number
                    number *= factorial
                    nextSet.add(number)
                    decompositions[number] = TreeMap(decompositions[original]!!)
                    decompositions[number]?.merge(multiplier, 1) { a, b -> a + b }
                }
            }
            jordanPolyaSet.addAll(nextSet)
            nextSet.clear()
        }
    }

    private fun toString(aMap: Map<Int, Int>): String {
        return aMap.entries.joinToString(separator = " * ") { (key, value) ->
            "$key!${if (value == 1) "" else "^$value"}"
        }
    }
}

fun main(args: Array<String>) {
    JordanPolyaNumbers.main(arrayOf<String>())
}
