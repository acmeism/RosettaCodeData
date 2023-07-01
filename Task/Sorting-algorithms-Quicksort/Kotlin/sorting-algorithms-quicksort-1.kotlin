fun <E : Comparable<E>> List<E>.qsort(): List<E> =
        if (size < 2) this
        else filter { it < first() }.qsort() +
                filter { it == first() } +
                filter { it > first() }.qsort()
