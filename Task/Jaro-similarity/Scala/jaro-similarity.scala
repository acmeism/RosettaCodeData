object Jaro extends App {

    def distance(s1: String, s2: String): Double = {
        val s1_len = s1.length
        val s2_len = s2.length
        if (s1_len == 0 && s2_len == 0) return 1.0
        val match_distance = Math.max(s1_len, s2_len) / 2 - 1
        val s1_matches = Array.ofDim[Boolean](s1_len)
        val s2_matches = Array.ofDim[Boolean](s2_len)
        var matches = 0
        for (i <- 0 until s1_len) {
            val start = Math.max(0, i - match_distance)
            val end = Math.min(i + match_distance + 1, s2_len)
            start until end find { j => !s2_matches(j) && s1(i) == s2(j) } match {
                case Some(j) =>
                    s1_matches(i) = true
                    s2_matches(j) = true
                    matches += 1
                case None =>
            }
        }
        if (matches == 0) return 0.0
        var t = 0.0
        var k = 0
        0 until s1_len filter s1_matches foreach { i =>
            while (!s2_matches(k)) k += 1
            if (s1(i) != s2(k)) t += 0.5
            k += 1
        }

        val m = matches.toDouble
        (m / s1_len + m / s2_len + (m - t) / m) / 3.0
    }

    val strings = List(("MARTHA", "MARHTA"), ("DIXON", "DICKSONX"), ("JELLYFISH", "SMELLYFISH"))
    strings.foreach { s => println(distance(s._1, s._2)) }
}
