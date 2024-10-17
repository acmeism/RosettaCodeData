// version 1.1.3

import java.io.File

fun main(args: Array<String>) {
    val text = File("135-0.txt").readText().toLowerCase()
    val r = Regex("""\p{javaLowerCase}+""")
    val matches = r.findAll(text)
    val wordGroups = matches.map { it.value }
                    .groupBy { it }
                    .map { Pair(it.key, it.value.size) }
                    .sortedByDescending { it.second }
                    .take(10)
    println("Rank  Word  Frequency")
    println("====  ====  =========")
    var rank = 1
    for ((word, freq) in wordGroups)
        System.out.printf("%2d    %-4s    %5d\n", rank++, word, freq)
}
