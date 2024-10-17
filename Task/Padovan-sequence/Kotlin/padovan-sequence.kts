import kotlin.math.floor
import kotlin.math.pow

object CodeKt{

    private val recurrences = mutableListOf<Int>()
    private val floors = mutableListOf<Int>()
    private const val PP = 1.324717957244746025960908854
    private const val SS = 1.0453567932525329623

    @JvmStatic
    fun main(args: Array<String>) {
        for (i in 0 until 64) {
            recurrences.add(padovanRecurrence(i))
            floors.add(padovanFloor(i))
        }

        println("The first 20 terms of the Padovan sequence:")
        recurrences.subList(0, 20).forEach { term -> print("$term ") }
        println("\n")

        println("Recurrence and floor functions agree for first 64 terms? ${recurrences == floors}\n")

        val words = createLSystem()

        println("The first 10 terms of the L-system:")
        words.subList(0, 10).forEach { term -> print("$term ") }
        println("\n")

        print("Length of first 32 terms produced from the L-system match Padovan sequence? ")
        val wordLengths = words.map { it.length }
        println(wordLengths == recurrences.subList(0, 32))
    }

    private fun padovanRecurrence(n: Int): Int =
        if (n <= 2) 1 else recurrences[n - 2] + recurrences[n - 3]

    private fun padovanFloor(n: Int): Int =
        floor(PP.pow(n - 1) / SS + 0.5).toInt()

    private fun createLSystem(): List<String> {
        val words = mutableListOf<String>()
        var text = "A"

        while (words.size < 32) {
            words.add(text)
            text = text.map { ch ->
                when (ch) {
                    'A' -> "B"
                    'B' -> "C"
                    'C' -> "AB"
                    else -> throw AssertionError("Unexpected character found: $ch")
                }
            }.joinToString("")
        }

        return words
    }
}
