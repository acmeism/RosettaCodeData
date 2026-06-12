fun main() {
    val pairs = listOf(
        TwoWords("ALLOW", "LOLLY"),
        TwoWords("ROBIN", "SONIC"),
        TwoWords("CHANT", "LATTE"),
        TwoWords("We're", "She's"),
        TwoWords("NOMAD", "MAMMA")
    )

    for (pair in pairs) {
        println("${pair.answer} v ${pair.guess} -> ${wordle(pair.answer, pair.guess)}")
    }
}

private fun wordle(answer: String, guess: String): List<Colour> {
    val guessLength = guess.length
    require(answer.length == guessLength) { "The two words must be of the same length." }

    var answerCopy = answer
    val result = MutableList(guessLength) { Colour.GREY }
    for (i in guess.indices) {
        if (answer[i] == guess[i]) {
            answerCopy = answerCopy.substring(0, i) + NULL + answerCopy.substring(i + 1)
            result[i] = Colour.GREEN
        }
    }

    for (i in guess.indices) {
        val index = answerCopy.indexOf(guess[i])
        if (index >= 0) {
            answerCopy = answerCopy.substring(0, index) + NULL + answerCopy.substring(index + 1)
            if (result[i] != Colour.GREEN) {
                result[i] = Colour.YELLOW
            }
        }
    }
    return result
}

private enum class Colour { GREEN, GREY, YELLOW }

private data class TwoWords(val answer: String, val guess: String)

private const val NULL = '\u0000'
