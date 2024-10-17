// purely functional & lazy version, leveraging recursion and Sequences (a.k.a. streams)
fun <T> Set<T>.subsets(): Sequence<Set<T>> =
    when (size) {
        0 -> sequenceOf(emptySet())
        else -> {
            val head = first()
            val tail = this - head
            tail.subsets() + tail.subsets().map { setOf(head) + it }
        }
    }

// if recursion is an issue, you may change it this way:

fun <T> Set<T>.subsets(): Sequence<Set<T>> = sequence {
    when (size) {
        0 -> yield(emptySet<T>())
        else -> {
            val head = first()
            val tail = this@subsets - head
            yieldAll(tail.subsets())
            for (subset in tail.subsets()) {
                yield(setOf(head) + subset)
            }
        }
    }
}
