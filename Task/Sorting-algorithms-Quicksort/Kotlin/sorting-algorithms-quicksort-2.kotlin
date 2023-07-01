fun <E : Comparable<E>> List<E>.qsort(): List<E> =
        if (size < 2) this
        else {
            val (less, high) = subList(1, size).partition { it < first() }
            less.qsort() + first() + high.qsort()
        }
