// version 1.0.6

fun makeList(sep: String): String {
    var count = 0
    fun makeItem(item: String): String {
        count++
        return "$count$sep$item\n"
    }
    return makeItem("first") + makeItem("second") + makeItem("third")
}

fun main(args: Array<String>) {
    print(makeList(". "))
}
