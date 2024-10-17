fun <T> modeOf(a: Array<T>) {
    val sortedByFreq = a.groupBy { it }.entries.sortedByDescending { it.value.size }
    val maxFreq = sortedByFreq.first().value.size
    val modes = sortedByFreq.takeWhile { it.value.size == maxFreq }
    if (modes.size == 1)
       println("The mode of the collection is ${modes.first().key} which has a frequency of $maxFreq")
    else {
       print("There are ${modes.size} modes with a frequency of $maxFreq, namely : ")
       println(modes.map { it.key }.joinToString(", "))
    }
}

fun main(args: Array<String>) {
    val a = arrayOf(7, 1, 1, 6, 2, 4, 2, 4, 2, 1, 5)
    println("[" + a.joinToString(", ") + "]")
    modeOf(a)
    println()
    val b = arrayOf(true, false, true, false, true, true)
    println("[" + b.joinToString(", ") + "]")
    modeOf(b)
}
