// version 1.2.10

import java.util.Random

val rand = Random()
const val RAND_MAX = 32767

lateinit var map: IntArray
var w = 0
var ww = 0

const val ALPHA = "+.ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
const val ALEN = ALPHA.length - 3

fun makeMap(p: Double) {
    val thresh = (p * RAND_MAX).toInt()
    ww = w * w
    var i = ww
    map = IntArray(i)
    while (i-- != 0) {
        val r = rand.nextInt(RAND_MAX + 1)
        if (r < thresh) map[i] = -1
    }
}

fun showCluster() {
    var k = 0
    for (i in 0 until w) {
        for (j in 0 until w) {
            val s = map[k++]
            val c = if (s < ALEN) ALPHA[1 + s] else '?'
            print(" $c")
        }
        println()
    }
}

fun recur(x: Int, v: Int) {
    if ((x in 0 until ww) && map[x] == -1) {
        map[x] = v
        recur(x - w, v)
        recur(x - 1, v)
        recur(x + 1, v)
        recur(x + w, v)
    }
}

fun countClusters(): Int {
    var cls = 0
    for (i in 0 until ww) {
        if (map[i] != -1) continue
        recur(i, ++cls)
    }
    return cls
}

fun tests(n: Int, p: Double): Double {
    var k = 0.0
    for (i in 0 until n) {
        makeMap(p)
        k += countClusters().toDouble() / ww
    }
    return k / n
}

fun main(args: Array<String>) {
    w = 15
    makeMap(0.5)
    val cls = countClusters()
    println("width = 15, p = 0.5, $cls clusters:")
    showCluster()

    println("\np = 0.5, iter = 5:")
    w = 1 shl 2
    while (w <= 1 shl 13) {
        val t = tests(5, 0.5)
        println("%5d %9.6f".format(w, t))
        w = w shl 1
    }
}
