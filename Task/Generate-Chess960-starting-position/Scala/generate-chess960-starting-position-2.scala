object Chess960 extends App {
    private def apply(b: String, e: String) {
        if (e.length <= 1) {
            val s = b + e
            if (is_valid(s)) patterns += s
        } else
            for (i <- 0 until e.length)
                apply(b + e(i), e.substring(0, i) + e.substring(i + 1))
    }

    private def is_valid(s: String) = {
        val k = s.indexOf('K')
        if (k < s.indexOf('R')) false
        else k < s.lastIndexOf('R') && s.indexOf('B') % 2 != s.lastIndexOf('B') % 2
    }

    private val patterns = scala.collection.mutable.SortedSet[String]()

    apply("", "KQRRNNBB")
    for ((s, i) <- patterns.zipWithIndex) println(s"$i: $s")
}
