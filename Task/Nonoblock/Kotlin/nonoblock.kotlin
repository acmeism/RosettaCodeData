// version 1.2.0

fun printBlock(data: String, len: Int) {
    val a = data.toCharArray()
    val sumChars = a.map { it.toInt() - 48 }.sum()
    println("\nblocks ${a.asList()}, cells $len")
    if (len - sumChars <= 0) {
        println("No solution")
        return
    }
    val prep = a.map { "1".repeat(it.toInt() - 48) }
    for (r in genSequence(prep, len - sumChars + 1)) println(r.substring(1))
}

fun genSequence(ones: List<String>, numZeros: Int): List<String> {
    if (ones.isEmpty()) return listOf("0".repeat(numZeros))
    val result = mutableListOf<String>()
    for (x in 1 until numZeros - ones.size + 2) {
        val skipOne = ones.drop(1)
        for (tail in genSequence(skipOne, numZeros - x)) {
            result.add("0".repeat(x) + ones[0] + tail)
        }
    }
    return result
}

fun main(args: Array<String>) {
    printBlock("21", 5)
    printBlock("", 5)
    printBlock("8", 10)
    printBlock("2323", 15)
    printBlock("23", 5)
}
