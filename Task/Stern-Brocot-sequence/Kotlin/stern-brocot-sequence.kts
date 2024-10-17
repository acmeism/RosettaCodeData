// version 1.1.0

val sbs = mutableListOf(1, 1)

fun sternBrocot(n: Int, fromStart: Boolean = true) {
    if (n < 4 || (n % 2 != 0)) throw IllegalArgumentException("n must be >= 4 and even")
    var consider = if (fromStart) 1 else n / 2 - 1
    while (true) {
        val sum = sbs[consider] + sbs[consider - 1]
        sbs.add(sum)
        sbs.add(sbs[consider])
        if (sbs.size == n) break
        consider++
    }
}

fun gcd(a: Int, b: Int): Int = if (b == 0) a else gcd(b, a % b)

fun main(args: Array<String>) {
    var n = 16  // needs to be even to ensure 'considered' number is added
    println("First 15 members of the Stern-Brocot sequence")
    sternBrocot(n)
    println(sbs.take(15))

    val firstFind = IntArray(11)  // all zero by default
    firstFind[0] = -1 // needs to be non-zero for subsequent test
    for ((i, v) in sbs.withIndex())
        if (v <= 10 && firstFind[v] == 0) firstFind[v] = i + 1
    loop@ while (true) {
        n += 2
        sternBrocot(n, false)
        val vv = sbs.takeLast(2)
        var m = n - 1
        for (v in vv) {
            if (v <= 10 && firstFind[v] == 0) firstFind[v] = m
            if (firstFind.all { it != 0 }) break@loop
            m++
        }
    }
    println("\nThe numbers 1 to 10 first appear at the following indices:")
    for (i in 1..10) println("${"%2d".format(i)} -> ${firstFind[i]}")

    print("\n100 first appears at index ")
    while (true) {
        n += 2
        sternBrocot(n, false)
        val vv = sbs.takeLast(2)
        if (vv[0] == 100) {
            println(n - 1); break
        }
        if (vv[1] == 100) {
            println(n); break
        }
    }

    print("\nThe GCDs of each pair of the series up to the 1000th member are ")
    for (p in 0..998 step 2) {
        if (gcd(sbs[p], sbs[p + 1]) != 1) {
            println("not all one")
            return
        }
    }
    println("all one")
}
