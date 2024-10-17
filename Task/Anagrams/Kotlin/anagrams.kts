import java.io.BufferedReader
import java.io.InputStreamReader
import java.net.URL
import kotlin.math.max

fun main() {
    val url = URL("http://wiki.puzzlers.org/pub/wordlists/unixdict.txt")
    val isr = InputStreamReader(url.openStream())
    val reader = BufferedReader(isr)
    val anagrams = mutableMapOf<String, MutableList<String>>()
    var count = 0
    var word = reader.readLine()
    while (word != null) {
        val chars = word.toCharArray()
        chars.sort()
        val key = chars.joinToString("")
        if (!anagrams.containsKey(key)) anagrams[key] = mutableListOf()
        anagrams[key]?.add(word)
        count = max(count, anagrams[key]?.size ?: 0)
        word = reader.readLine()
    }
    reader.close()
    anagrams.values
        .filter { it.size == count }
        .forEach { println(it) }
}
