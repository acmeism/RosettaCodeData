// version 1.0.6

import java.net.URL
import java.io.InputStreamReader
import java.io.BufferedReader

fun isPlausible(n1: Int, n2: Int) = n1 > 2 * n2

fun printResults(source: String, counts: IntArray) {
    println("Results for $source")
    println("  i before e except after c")
    println("    for     ${counts[0]}")
    println("    against ${counts[1]}")
    val plausible1 = isPlausible(counts[0], counts[1])
    println("  sub-rule is${if (plausible1) "" else " not"} plausible\n")
    println("  e before i when preceded by c")
    println("    for     ${counts[2]}")
    println("    against ${counts[3]}")
    val plausible2 = isPlausible(counts[2], counts[3])
    println("  sub-rule is${if (plausible2) "" else " not"} plausible\n")
    val plausible = plausible1 && plausible2
    println("  rule is${if (plausible) "" else " not"} plausible")
}

fun main(args: Array<String>) {
    val url = URL("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
    val isr = InputStreamReader(url.openStream())
    val reader = BufferedReader(isr)
    val regexes = arrayOf(
        Regex("(^|[^c])ie"),     // i before e when not preceded by c (includes words starting with ie)
        Regex("(^|[^c])ei"),     // e before i when not preceded by c (includes words starting with ei)
        Regex("cei"),            // e before i when preceded by c
        Regex("cie")             // i before e when preceded by c
    )
    val counts = IntArray(4) // corresponding counts of occurrences
    var word = reader.readLine()
    while (word != null) {
        for (i in 0..3) counts[i] += regexes[i].findAll(word).toList().size
        word = reader.readLine()
    }
    reader.close()
    printResults("unixdict.txt", counts)

    val url2 = URL("http://ucrel.lancs.ac.uk/bncfreq/lists/1_2_all_freq.txt")
    val isr2 = InputStreamReader(url2.openStream())
    val reader2 = BufferedReader(isr2)
    val counts2 = IntArray(4)
    reader2.readLine() // read header line
    var line = reader2.readLine() // read first line and store it
    var words: List<String>
    val splitter = Regex("""(\t+|\s+)""")
    while (line != null) {
        words = line.split(splitter)
        if (words.size == 4)  // first element is empty
            for (i in 0..3) counts2[i] += regexes[i].findAll(words[1]).toList().size * words[3].toInt()
        line = reader2.readLine()
    }
    reader2.close()
    println()
    printResults("British National Corpus", counts2)
}
