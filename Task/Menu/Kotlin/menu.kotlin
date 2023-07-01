// version 1.1.2

fun menu(list: List<String>): String {
    if (list.isEmpty()) return ""
    val n = list.size
    while (true) {
        println("\n   M E N U\n")
        for (i in 0 until n) println("${i + 1}: ${list[i]}")
        print("\nEnter your choice 1 - $n : ")
        val index = readLine()!!.toIntOrNull()
        if (index == null || index !in 1..n) continue
        return list[index - 1]
    }
}

fun main(args: Array<String>) {
    val list = listOf(
        "fee fie",
        "huff and puff",
        "mirror mirror",
        "tick tock"
    )
    val choice = menu(list)
    println("\nYou chose : $choice")
}
