fun removeVowels(s: String): String {
    val re = StringBuilder()
    for (c in s) {
        if (c != 'A' && c != 'a'
            && c != 'E' && c != 'e'
            && c != 'I' && c != 'i'
            && c != 'O' && c != 'o'
            && c != 'U' && c != 'u') {
            re.append(c)
        }
    }
    return re.toString()
}

fun main() {
    println(removeVowels("Kotlin Programming Language"))
}
