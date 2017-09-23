// version 1.1.4-3

import java.io.File

val wordList = "unixdict.txt"
val url = "http://www.puzzlers.org/pub/wordlists/unixdict.txt"

const val DIGITS = "22233344455566677778889999"

val map = mutableMapOf<String, MutableList<String>>()

fun processList() {
    var countValid = 0
    val f = File(wordList)
    val sb = StringBuilder()

    f.forEachLine { word->
        var valid = true
        sb.setLength(0)
        for (c in word.toLowerCase()) {
            if (c !in 'a'..'z') {
                valid = false
                break
            }
            sb.append(DIGITS[c - 'a'])
        }
        if (valid) {
            countValid++
            val key = sb.toString()
            if (map.containsKey(key)) {
                map[key]!!.add(word)
            }
            else {
                map.put(key, mutableListOf(word))
            }
        }
    }
    var textonyms = map.filter { it.value.size > 1 }.toList()
    val report = "There are $countValid words in '$url' " +
                 "which can be represented by the digit key mapping.\n" +
                 "They require ${map.size} digit combinations to represent them.\n" +
                 "${textonyms.size} digit combinations represent Textonyms.\n"
    println(report)

    val longest = textonyms.sortedByDescending { it.first.length }
    val ambiguous = longest.sortedByDescending { it.second.size }

    println("Top 8 in ambiguity:\n")
    println("Count   Textonym  Words")
    println("======  ========  =====")
    var fmt = "%4d    %-8s  %s"
    for (a in ambiguous.take(8)) println(fmt.format(a.second.size, a.first, a.second))

    fmt = fmt.replace("8", "14")
    println("\nTop 6 in length:\n")
    println("Length  Textonym        Words")
    println("======  ==============  =====")
    for (l in longest.take(6)) println(fmt.format(l.first.length, l.first, l.second))
}

fun main(args: Array<String>) {
    processList()
}
