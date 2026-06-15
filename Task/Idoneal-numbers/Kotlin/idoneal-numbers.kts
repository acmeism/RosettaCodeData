fun idoneals(limit: Int): Sequence<Int> {
    return generateSequence(1) {it + 1}
        .takeWhile{it <= limit}
        .filter{n -> (1 .. n)
            .all{a -> (a + 1 .. n)
                .takeWhile{b -> 2 * a * b + a + b < n}
                .all{b -> generateSequence(a * b + (b + 1) * (a + b))
                    {it + a + b}
                    .dropWhile{it < n}.first() > n
                }
            }
        }
}

fun main() {
    idoneals(2000).chunked(13).forEach{
        println(it.map{"%4d".format(it)}.joinToString(" "))
    }
} // © 2026
