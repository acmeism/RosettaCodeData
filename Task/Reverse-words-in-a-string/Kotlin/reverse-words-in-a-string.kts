fun reversedWords(s: String) = s.split(" ").filter { it.isNotEmpty() }.reversed().joinToString(" ")

fun main() {
    val s = "Hey you, Bub!"
    println(reversedWords(s))
    println()
    val sl = listOf(
        " ---------- Ice and Fire ------------ ",
        "                                      ",
        " fire, in end will world the say Some ",
        " ice. in say Some                     ",
        " desire of tasted I've what From      ",
        " fire. favor who those with hold I    ",
        "                                      ",
        " ... elided paragraph last ...        ",
        "                                      ",
        " Frost Robert ----------------------- ",
    )
    sl.forEach { println(reversedWords(it)) }
}
