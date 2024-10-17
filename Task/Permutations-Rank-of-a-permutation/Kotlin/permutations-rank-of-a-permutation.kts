// version 1.1.2

import java.util.Random

fun IntArray.swap(i: Int, j: Int) {
    val temp = this[i]
    this[i] = this[j]
    this[j] = temp
}

tailrec fun mrUnrank1(rank: Int, n: Int, vec: IntArray) {
    if (n < 1) return
    val q = rank / n
    val r = rank % n
    vec.swap(r, n - 1)
    mrUnrank1(q, n - 1, vec)
}

fun mrRank1(n: Int, vec: IntArray, inv: IntArray): Int {
    if (n < 2) return 0
    val s = vec[n - 1]
    vec.swap(n - 1, inv[n - 1])
    inv.swap(s, n - 1)
    return s + n * mrRank1(n - 1, vec, inv)
}

fun getPermutation(rank: Int, n: Int, vec: IntArray) {
    for (i in 0 until n) vec[i] = i
    mrUnrank1(rank, n, vec)
}

fun getRank(n: Int, vec: IntArray): Int {
    val v   = IntArray(n)
    val inv = IntArray(n)
    for (i in 0 until n) {
        v[i] = vec[i]
        inv[vec[i]] = i
    }
    return mrRank1(n, v, inv)
}

fun main(args: Array<String>) {
    var tv = IntArray(3)
    for (r in 0..5) {
        getPermutation(r, 3, tv)
        System.out.printf("%2d -> %s -> %d\n", r, tv.contentToString(), getRank(3, tv))
    }
    println()
    tv = IntArray(4)
    for (r in 0..23) {
        getPermutation(r, 4, tv)
        System.out.printf("%2d -> %s -> %d\n", r, tv.contentToString(), getRank(4, tv))
    }

    println()
    tv = IntArray(12)
    val a = IntArray(4)
    val rand = Random()
    val fact12 = (2..12).fold(1) { acc, i -> acc * i }
    for (i in 0..3) a[i] = rand.nextInt(fact12)
    for (r in a) {
        getPermutation(r, 12, tv)
        System.out.printf("%9d -> %s -> %d\n", r, tv.contentToString(), getRank(12, tv))
    }
}
