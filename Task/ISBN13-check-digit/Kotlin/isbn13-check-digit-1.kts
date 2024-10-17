fun isValidISBN13(text: String): Boolean {
    val isbn = text.replace(Regex("[- ]"), "")
    return isbn.length == 13 && isbn.map { it - '0' }
        .mapIndexed { index, value -> when (index % 2) { 0 -> value else -> 3 * value } }
        .sum() % 10 == 0
}
