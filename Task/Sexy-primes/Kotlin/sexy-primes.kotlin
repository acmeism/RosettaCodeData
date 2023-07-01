// Version 1.2.71

fun sieve(lim: Int): BooleanArray {
    var limit = lim + 1
    // True denotes composite, false denotes prime.
    val c = BooleanArray(limit)  // all false by default
    c[0] = true
    c[1] = true
    // No need to bother with even numbers over 2 for this task.
    var p = 3  // Start from 3.
    while (true) {
        val p2 = p * p
        if (p2 >= limit) break
        for (i in p2 until limit step 2 * p) c[i] = true
        while (true) {
            p += 2
            if (!c[p]) break
        }
    }
    return c
}

fun printHelper(cat: String, len: Int, lim: Int, max: Int): Pair<Int, String> {
    val cat2 = if (cat != "unsexy primes") "sexy prime " + cat  else cat
    System.out.printf("Number of %s less than %d = %,d\n", cat2, lim, len)
    val last = if (len < max) len else max
    val verb = if (last == 1) "is" else "are"
    return last to verb
}

fun main(args: Array<String>) {
    val lim = 1_000_035
    val sv = sieve(lim - 1)
    val pairs = mutableListOf<List<Int>>()
    val trips = mutableListOf<List<Int>>()
    val quads = mutableListOf<List<Int>>()
    val quins = mutableListOf<List<Int>>()
    val unsexy = mutableListOf(2, 3)
    for (i in 3 until lim step 2) {
        if (i > 5 && i < lim - 6 && !sv[i] && sv[i - 6] && sv[i + 6]) {
            unsexy.add(i)
            continue
        }

        if (i < lim - 6 && !sv[i] && !sv[i + 6]) {
            val pair = listOf(i, i + 6)
            pairs.add(pair)
        } else continue

        if (i < lim - 12 && !sv[i + 12]) {
            val trip = listOf(i, i + 6, i + 12)
            trips.add(trip)
        } else continue

        if (i < lim - 18 && !sv[i + 18]) {
            val quad = listOf(i, i + 6, i + 12, i + 18)
            quads.add(quad)
        } else continue

        if (i < lim - 24 && !sv[i + 24]) {
            val quin = listOf(i, i + 6, i + 12, i + 18, i + 24)
            quins.add(quin)
        }
    }

    var (n2, verb2) = printHelper("pairs", pairs.size, lim, 5)
    System.out.printf("The last %d %s:\n  %s\n\n", n2, verb2, pairs.takeLast(n2))

    var (n3, verb3) = printHelper("triplets", trips.size, lim, 5)
    System.out.printf("The last %d %s:\n  %s\n\n", n3, verb3, trips.takeLast(n3))

    var (n4, verb4) = printHelper("quadruplets", quads.size, lim, 5)
    System.out.printf("The last %d %s:\n  %s\n\n", n4, verb4, quads.takeLast(n4))

    var (n5, verb5) = printHelper("quintuplets", quins.size, lim, 5)
    System.out.printf("The last %d %s:\n  %s\n\n", n5, verb5, quins.takeLast(n5))

    var (nu, verbu) = printHelper("unsexy primes", unsexy.size, lim, 10)
    System.out.printf("The last %d %s:\n  %s\n\n", nu, verbu, unsexy.takeLast(nu))
}
