// version 1.3.10

import java.io.File

fun markov(filePath: String, keySize: Int, outputSize: Int): String {
    require(keySize >= 1) { "Key size can't be less than 1" }

    val words = File(filePath).readText().trimEnd().split(' ')
    require(outputSize in keySize..words.size) { "Output size is out of range" }

    val dict = mutableMapOf<String, MutableList<String>>()

    for (i in 0..(words.size - keySize)) {
        val prefix = words.subList(i, i + keySize).joinToString(" ")
        val suffix = if (i + keySize < words.size) words[i + keySize] else ""
        val suffixes = dict.getOrPut(prefix) { mutableListOf() }
        suffixes += suffix
    }

    val output = mutableListOf<String>()
    var prefix = dict.keys.random()
    output += prefix.split(' ')

    for (n in 1..words.size) {
        val nextWord = dict[prefix]!!.random()
        if (nextWord.isEmpty()) break

        output += nextWord
        if (output.size >= outputSize) break

        prefix = output.subList(n, n + keySize).joinToString(" ")
    }

    return output.take(outputSize).joinToString(" ")
}

fun main() {
    println(markov("alice_oz.txt", 3, 100))
}
