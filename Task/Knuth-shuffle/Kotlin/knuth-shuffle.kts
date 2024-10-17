object Knuth {
    internal val gen = java.util.Random()
}

fun <T> Array<T>.shuffle(): Array<T> {
    val a = clone()
    var n = a.size
    while (n > 1) {
        val k = Knuth.gen.nextInt(n--)
        val t = a[n]
        a[n] = a[k]
        a[k] = t
    }
    return a
}

fun main(args: Array<String>) {
    val str = "abcdefghijklmnopqrstuvwxyz".toCharArray()
    (1..10).forEach {
        val s = str.toTypedArray().shuffle().toCharArray()
        println(s)
        require(s.toSortedSet() == str.toSortedSet())
    }

    val ia = arrayOf(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    (1..10).forEach {
        val s = ia.shuffle()
        println(s.distinct())
        require(s.toSortedSet() == ia.toSet())
    }
}
