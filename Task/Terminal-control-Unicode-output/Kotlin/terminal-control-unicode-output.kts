// version 1.1.2

fun main(args: Array<String>) {
    val supportsUnicode = "UTF" in System.getenv("LANG").toUpperCase()
    if (supportsUnicode)
        println("This terminal supports unicode and U+25b3 is : \u25b3")
    else
        println("This terminal does not support unicode")
}
