import java.io.File
import kotlin.math.max

fun getMinimumPrefixLength(distinctWords: Iterable<String>): Int {
    return distinctWords
        .sorted()
        .fold(Pair("", 0),
            { (previousWord, minLength), currentWord ->
                val firstNonMatchingIdx = previousWord
                    .asSequence()
                    .zip(currentWord.asSequence())
                    .indexOfFirst { it.first != it.second }
                return@fold Pair(
                    currentWord,
                    max(
                        // firstNonMatchingIdx would be -1 iff  previousWord is a prefix of currentWord
                        if (firstNonMatchingIdx != -1) firstNonMatchingIdx + 1 else previousWord.length + 1,
                        minLength)
                )
            })
        .second
}

fun getMinimumPrefixLength(whitespaceSeparatedDistinctWords: String) =
    getMinimumPrefixLength(whitespaceSeparatedDistinctWords.split(Regex("\\s+")))

fun main() {
    File("/tmp/input.txt").useLines {
        it.map(String::trim)
            .filter(String::isNotEmpty)
            .map({ "${getMinimumPrefixLength(it).toString().padEnd(5)} ${it}" })
            .forEach(::println)
    }
}
