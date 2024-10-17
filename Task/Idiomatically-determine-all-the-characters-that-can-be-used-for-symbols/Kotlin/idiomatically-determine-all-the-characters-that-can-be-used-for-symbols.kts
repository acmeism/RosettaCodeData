// version 1.1.4-3

typealias CharPredicate = (Char) -> Boolean

fun printChars(msg: String, start: Int, end: Int, limit: Int, p: CharPredicate, asInt: Boolean) {
    print(msg)
    (start until end).map { it.toChar() }
                     .filter { p(it) }
                     .take(limit)
                     .forEach { print(if (asInt) "[${it.toInt()}]" else it) }
    println("...")
}

fun main(args: Array<String>) {
    printChars("Kotlin Identifier start:     ", 0, 0x10FFFF, 72,
                Char::isJavaIdentifierStart, false)

    printChars("Kotlin Identifier part:      ", 0, 0x10FFFF, 25,
                Character::isJavaIdentifierPart, true)

    printChars("Kotlin Identifier ignorable: ", 0, 0x10FFFF, 25,
                Character::isIdentifierIgnorable, true)
}
