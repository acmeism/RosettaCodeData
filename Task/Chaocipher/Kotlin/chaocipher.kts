// Version 1.2.40

enum class Mode { ENCRYPT, DECRYPT }

object Chao {
    private val lAlphabet = "HXUCZVAMDSLKPEFJRIGTWOBNYQ"
    private val rAlphabet = "PTLNBQDEOYSFAVZKGJRIHWXUMC"

    fun exec(text: String, mode: Mode, showSteps: Boolean = false): String {
        var left  = lAlphabet
        var right = rAlphabet
        val eText = CharArray(text.length)
        val temp  = CharArray(26)

        for (i in 0 until text.length) {
            if (showSteps) println("$left  $right")
            var index: Int
            if (mode == Mode.ENCRYPT) {
                index = right.indexOf(text[i])
                eText[i] = left[index]
            }
            else {
                index = left.indexOf(text[i])
                eText[i] = right[index]
            }
            if (i == text.length - 1) break

            // permute left

            for (j in index..25) temp[j - index] = left[j]
            for (j in 0 until index) temp[26 - index + j] = left[j]
            var store = temp[1]
            for (j in 2..13) temp[j - 1] = temp[j]
            temp[13] = store
            left = String(temp)

            // permute right

            for (j in index..25) temp[j - index] = right[j]
            for (j in 0 until index) temp[26 - index + j] = right[j]
            store = temp[0]
            for (j in 1..25) temp[j - 1] = temp[j]
            temp[25] = store
            store = temp[2]
            for (j in 3..13) temp[j - 1] = temp[j]
            temp[13] = store
            right = String(temp)
        }

        return String(eText)
    }
}

fun main(args: Array<String>) {
    val plainText = "WELLDONEISBETTERTHANWELLSAID"
    println("The original plaintext is : $plainText")
    println("\nThe left and right alphabets after each permutation" +
             " during encryption are :\n")
    val cipherText = Chao.exec(plainText, Mode.ENCRYPT, true)
    println("\nThe ciphertext is : $cipherText")
    val plainText2 = Chao.exec(cipherText, Mode.DECRYPT)
    println("\nThe recovered plaintext is : $plainText2")
}
