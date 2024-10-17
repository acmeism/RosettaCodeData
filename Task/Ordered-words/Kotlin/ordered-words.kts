import java.net.URI

fun main() {
    val url = URI(
        "https://web.archive.org/web/20180611003215/http://www.puzzlers.org/pub/wordlists/unixdict.txt"
    ).toURL()
    val words = url.openStream().bufferedReader().use {
        var max = 0
        it.lineSequence()
            .filter { it.asSequence().windowed(2).all { it[0] <= it[1] } }
            .sortedByDescending(String::length)
            .takeWhile { word -> word.length >= max.also { max = word.length } }
            .toList()
    }
    words.forEach(::println)
}
