object Chess960 : Iterable<String> {
    override fun iterator() = patterns.iterator()

    private operator fun invoke(b: String, e: String) {
        if (e.length <= 1) {
            val s = b + e
            if (s.is_valid()) patterns += s
        } else {
            for (i in 0 until e.length) {
                invoke(b + e[i], e.substring(0, i) + e.substring(i + 1))
            }
        }
    }

    private fun String.is_valid(): Boolean {
        val k = indexOf('K')
        return indexOf('R') < k && k < lastIndexOf('R') &&
            indexOf('B') % 2 != lastIndexOf('B') % 2
    }

    private val patterns = sortedSetOf<String>()

    init {
        invoke("", "KQRRNNBB")
    }
}

fun main(args: Array<String>) {
    Chess960.forEachIndexed { i, s -> println("$i: $s") }
}
