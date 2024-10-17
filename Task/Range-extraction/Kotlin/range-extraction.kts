// version 1.0.6

fun extractRange(list: List<Int>): String {
    if (list.isEmpty()) return ""
    val sb = StringBuilder()
    var first = list[0]
    var prev  = first

    fun append(index: Int) {
        if (first == prev) sb.append(prev)
        else if (first == prev - 1) sb.append(first, ",", prev)
        else sb.append(first, "-", prev)
        if (index < list.size - 1) sb.append(",")
    }

    for (i in 1 until list.size) {
        if (list[i] == prev + 1) prev++
        else {
            append(i)
            first = list[i]
            prev  = first
        }
    }
    append(list.size - 1)
    return sb.toString()
}

fun main(args: Array<String>) {
    val list1 = listOf(-6, -3, -2, -1, 0, 1, 3, 4, 5, 7, 8, 9, 10, 11, 14, 15, 17, 18, 19, 20)
    println(extractRange(list1))
    println()
    val list2 = listOf(0,  1,  2,  4,  6,  7,  8, 11, 12, 14,
                      15, 16, 17, 18, 19, 20, 21, 22, 23, 24,
                      25, 27, 28, 29, 30, 31, 32, 33, 35, 36,
                      37, 38, 39)
    println(extractRange(list2))
}
