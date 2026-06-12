fun main() {
    (0..99999).asSequence()
        .filter { it.toString(10).toSet() == it.toString(16).toSet() }
        .chunked(10) { it.joinToString(" ") { "%5d".format(it) } }
        .forEach(::println)
}
