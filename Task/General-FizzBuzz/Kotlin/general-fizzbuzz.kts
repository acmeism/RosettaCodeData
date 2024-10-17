fun main(args: Array<String>) {

    //Read the maximum number, set to 0 if it couldn't be read
    val max = readLine()?.toInt() ?: 0
    val words = mutableMapOf<Int, String>()

    //Read input three times for a factor and a word
    (1..3).forEach {
        readLine()?.let {
            val tokens = it.split(' ')
            words.put(tokens[0].toInt(), tokens[1])
        }
    }

    //Sort the words so they will be output in arithmetic order
    val sortedWords = words.toSortedMap()

    //Find the words with matching factors and print them, print the number if no factors match
    for (i in 1..max) {
        val wordsToPrint = sortedWords.filter { i % it.key == 0 }.map { it.value }
        if (wordsToPrint.isNotEmpty()) {
            wordsToPrint.forEach { print(it) }
            println()
        }
        else
            println(i)
    }
}
