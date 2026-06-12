fun main() {
    val list = listOf("Rosetta", "Code", "is", "a", "programming", "chrestomathy", "site")
    println(list.sortedBySchwartzian(String::length))
}

/**
 * Returns a sorted list using the Schwartzian Transform which guarantees minimal use of the
 * key extractor function. Use when the key extractor function is an expensive operation.
*/
fun <T, R: Comparable<R>> Collection<T>.sortedBySchwartzian(keyFn: (T) -> R): List<T> =
    this.map { it to keyFn(it) }
        .sortedBy { it.second }
        .map { it.first }
