object Bacon {
    private val codes = mapOf(
        'a' to "AAAAA", 'b' to "AAAAB", 'c' to "AAABA", 'd' to "AAABB", 'e' to "AABAA",
        'f' to "AABAB", 'g' to "AABBA", 'h' to "AABBB", 'i' to "ABAAA", 'j' to "ABAAB",
        'k' to "ABABA", 'l' to "ABABB", 'm' to "ABBAA", 'n' to "ABBAB", 'o' to "ABBBA",
        'p' to "ABBBB", 'q' to "BAAAA", 'r' to "BAAAB", 's' to "BAABA", 't' to "BAABB",
        'u' to "BABAA", 'v' to "BABAB", 'w' to "BABBA", 'x' to "BABBB", 'y' to "BBAAA",
        'z' to "BBAAB", ' ' to "BBBAA" // use ' ' to denote any non-letter
    )

    fun encode(plainText: String, message: String): String {
        val pt = plainText.toLowerCase()
        val sb = StringBuilder()
        for (c in pt)
            if (c in 'a'..'z') sb.append(codes[c])
            else sb.append(codes[' '])
        val et = sb.toString()
        val mg = message.toLowerCase()  // 'A's to be in lower case, 'B's in upper case
        sb.setLength(0)
        var count = 0
        for (c in mg)
            if (c in 'a'..'z') {
                if (et[count] == 'A') sb.append(c)
                else sb.append(c - 32) // upper case equivalent
                count++
                if (count == et.length) break
            } else sb.append(c)
        return sb.toString()
    }

    fun decode(message: String): String {
        val sb = StringBuilder()
        for (c in message)
            when (c) {
                in 'a'..'z' -> sb.append('A')
                in 'A'..'Z' -> sb.append('B')
            }
        val et = sb.toString()
        sb.setLength(0)
        for (i in 0 until et.length step 5) {
            val quintet = et.substring(i, i + 5)
            val key = codes.entries.find { it.value == quintet }!!.key
            sb.append(key)
        }
        return sb.toString()
    }
}

fun main(args: Array<String>) {
    val plainText = "the quick brown fox jumps over the lazy dog"
    val message = "bacon's cipher is a method of steganography created by francis bacon." +
        "this task is to implement a program for encryption and decryption of " +
        "plaintext using the simple alphabet of the baconian cipher or some " +
        "other kind of representation of this alphabet (make anything signify anything). " +
        "the baconian alphabet may optionally be extended to encode all lower " +
        "case characters individually and/or adding a few punctuation characters " +
        "such as the space."
    val cipherText = Bacon.encode(plainText, message)
    println("Cipher text ->\n\n$cipherText")
    val decodedText = Bacon.decode(cipherText)
    println("\nHidden text ->\n\n$decodedText")
}
