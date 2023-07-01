// version 1.2.21

typealias DList = List<Double>

enum class Direction { UP, DOWN }

// test also for 'Unknown' correction type
val types = listOf(
    "Benjamini-Hochberg", "Benjamini-Yekutieli", "Bonferroni", "Hochberg",
    "Holm", "Hommel", "Šidák", "Unknown"
)

fun adjusted(p: DList, type: String) = "\n$type\n${pFormat(adjust(check(p), type))}"

fun pFormat(p: DList, cols: Int = 5): String {
    var i = -cols
    val fmt = "%1.10f"
    return p.chunked(cols).map { chunk ->
        i += cols
        "[%2d]  %s".format(i, chunk.map { fmt.format(it) }.joinToString(" "))
    }.joinToString("\n")
}

fun check(p: DList): DList {
    require(p.size > 0 && p.min()!! >= 0.0 && p.max()!! <= 1.0) {
        "p-values must be in range 0.0 to 1.0"
    }
    return p
}

fun ratchet(p: DList, dir: Direction): DList {
    val pp = p.toMutableList()
    var m = pp[0]
    if (dir == Direction.UP) {
        for (i in 1 until pp.size) {
            if (pp[i] > m) pp[i] = m
            m = pp[i]
        }
    }
    else {
        for (i in 1 until pp.size) {
            if (pp[i] < m) pp[i] = m
            m = pp[i]
        }
    }
    return pp.map { if (it < 1.0) it else 1.0 }
}

fun schwartzian(p: DList, mult: DList, dir: Direction): DList {
    val size = p.size
    val order = if (dir == Direction.UP)
        p.withIndex().sortedByDescending { it.value }.map { it.index }
    else
        p.withIndex().sortedBy { it.value }.map { it.index }
    var pa = List(size) { mult[it] * p[order[it]] }
    pa = ratchet(pa, dir)
    val order2 = order.withIndex().sortedBy{ it.value }.map { it.index }
    return List(size) { pa[order2[it]] }
}

fun adjust(p: DList, type: String): DList {
    val size = p.size
    require(size > 0)
    when (type) {
        "Benjamini-Hochberg" -> {
            val mult = List(size) { size.toDouble() / (size - it) }
            return schwartzian(p, mult, Direction.UP)
        }

        "Benjamini-Yekutieli" -> {
            val q = (1..size).sumByDouble { 1.0 / it }
            val mult = List(size) { q * size / (size - it) }
            return schwartzian(p, mult, Direction.UP)
        }

        "Bonferroni" -> {
            return p.map { minOf(it * size, 1.0) }
        }

        "Hochberg" -> {
            val mult = List(size) { (it + 1).toDouble() }
            return schwartzian(p, mult, Direction.UP)
        }

        "Holm" -> {
            val mult = List(size) { (size - it).toDouble() }
            return schwartzian(p, mult, Direction.DOWN)
        }

        "Hommel" -> {
            val order = p.withIndex().sortedBy { it.value }.map { it.index }
            val s = List(size) { p[order[it]] }
            val min = List(size){ s[it] * size / ( it + 1) }.min()!!
            val q = MutableList(size) { min }
            val pa = MutableList(size) { min }
            for (j in size - 1 downTo 2) {
                val lower = IntArray(size - j + 1) { it }          // lower indices
                val upper = IntArray(j - 1) { size - j + 1 + it }  // upper indices
                var qmin = j * s[upper[0]] / 2.0
                for (i in 1 until upper.size) {
                    val temp = s[upper[i]] * j / (2.0 + i)
                    if (temp < qmin) qmin = temp
                }
                for (i in 0 until lower.size) {
                    q[lower[i]] = minOf(s[lower[i]] * j, qmin)
                }
                for (i in 0 until upper.size) q[upper[i]] = q[size - j]
                for (i in 0 until size) if (pa[i] < q[i]) pa[i] = q[i]
            }
            val order2 = order.withIndex().sortedBy{ it.value }.map { it.index }
            return List(size) { pa[order2[it]] }
        }

        "Šidák" -> {
            val m = size.toDouble()
            return p.map { 1.0 - Math.pow(1.0 - it, m) }
        }

        else -> {
            println(
                "\nSorry, do not know how to do '$type' correction.\n" +
                "Perhaps you want one of these?:\n" +
                types.dropLast(1).map { "  $it" }.joinToString("\n")
            )
            System.exit(1)
        }
    }
    return p
}

fun main(args: Array<String>) {
    val pValues = listOf(
        4.533744e-01, 7.296024e-01, 9.936026e-02, 9.079658e-02, 1.801962e-01,
        8.752257e-01, 2.922222e-01, 9.115421e-01, 4.355806e-01, 5.324867e-01,
        4.926798e-01, 5.802978e-01, 3.485442e-01, 7.883130e-01, 2.729308e-01,
        8.502518e-01, 4.268138e-01, 6.442008e-01, 3.030266e-01, 5.001555e-02,
        3.194810e-01, 7.892933e-01, 9.991834e-01, 1.745691e-01, 9.037516e-01,
        1.198578e-01, 3.966083e-01, 1.403837e-02, 7.328671e-01, 6.793476e-02,
        4.040730e-03, 3.033349e-04, 1.125147e-02, 2.375072e-02, 5.818542e-04,
        3.075482e-04, 8.251272e-03, 1.356534e-03, 1.360696e-02, 3.764588e-04,
        1.801145e-05, 2.504456e-07, 3.310253e-02, 9.427839e-03, 8.791153e-04,
        2.177831e-04, 9.693054e-04, 6.610250e-05, 2.900813e-02, 5.735490e-03
    )

    types.forEach { println(adjusted(pValues, it)) }
}
