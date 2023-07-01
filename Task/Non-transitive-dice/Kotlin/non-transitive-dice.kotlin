fun fourFaceCombos(): List<Array<Int>> {
    val res = mutableListOf<Array<Int>>()
    val found = mutableSetOf<Int>()
    for (i in 1..4) {
        for (j in 1..4) {
            for (k in 1..4) {
                for (l in 1..4) {
                    val c = arrayOf(i, j, k, l)
                    c.sort()
                    val key = 64 * (c[0] - 1) + 16 * (c[1] - 1) + 4 * (c[2] - 1) + (c[3] - 1)
                    if (!found.contains(key)) {
                        found.add(key)
                        res.add(c)
                    }
                }
            }
        }
    }
    return res
}

fun cmp(x: Array<Int>, y: Array<Int>): Int {
    var xw = 0
    var yw = 0
    for (i in 0 until 4) {
        for (j in 0 until 4) {
            if (x[i] > y[j]) {
                xw++
            } else if (y[j] > x[i]) {
                yw++
            }
        }
    }
    if (xw < yw) {
        return -1
    }
    if (xw > yw) {
        return 1
    }
    return 0
}

fun findIntransitive3(cs: List<Array<Int>>): List<Array<Array<Int>>> {
    val c = cs.size
    val res = mutableListOf<Array<Array<Int>>>()

    for (i in 0 until c) {
        for (j in 0 until c) {
            if (cmp(cs[i], cs[j]) == -1) {
                for (k in 0 until c) {
                    if (cmp(cs[j], cs[k]) == -1 && cmp(cs[k], cs[i]) == -1) {
                        res.add(arrayOf(cs[i], cs[j], cs[k]))
                    }
                }
            }
        }
    }

    return res
}

fun findIntransitive4(cs: List<Array<Int>>): List<Array<Array<Int>>> {
    val c = cs.size
    val res = mutableListOf<Array<Array<Int>>>()

    for (i in 0 until c) {
        for (j in 0 until c) {
            if (cmp(cs[i], cs[j]) == -1) {
                for (k in 0 until c) {
                    if (cmp(cs[j], cs[k]) == -1) {
                        for (l in 0 until c) {
                            if (cmp(cs[k], cs[l]) == -1 && cmp(cs[l], cs[i]) == -1) {
                                res.add(arrayOf(cs[i], cs[j], cs[k], cs[l]))
                            }
                        }
                    }
                }
            }
        }
    }

    return res
}

fun main() {
    val combos = fourFaceCombos()
    println("Number of eligible 4-faced dice: ${combos.size}")
    println()

    val it3 = findIntransitive3(combos)
    println("${it3.size} ordered lists of 3 non-transitive dice found, namely:")
    for (a in it3) {
        println(a.joinToString(", ", "[", "]") { it.joinToString(", ", "[", "]") })
    }
    println()

    val it4 = findIntransitive4(combos)
    println("${it4.size} ordered lists of 4 non-transitive dice found, namely:")
    for (a in it4) {
        println(a.joinToString(", ", "[", "]") { it.joinToString(", ", "[", "]") })
    }
}
