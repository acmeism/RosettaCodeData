// version 1.1.4-3

typealias List2D<T> = List<List<T>>

const val S = 10

class Node(var v: Double, var fixed: Int)

fun setBoundary(m: List2D<Node>) {
    m[1][1].v =  1.0; m[1][1].fixed =  1
    m[6][7].v = -1.0; m[6][7].fixed = -1
}

fun calcDiff(m: List2D<Node>, d: List2D<Node>, w: Int, h: Int): Double {
    var total = 0.0
    for (i in 0 until h) {
        for (j in 0 until w) {
            var v = 0.0
            var n = 0
            if (i > 0) { v += m[i - 1][j].v; n++ }
            if (j > 0) { v += m[i][j - 1].v; n++ }
            if (i + 1 < h) { v += m[i + 1][j].v; n++ }
            if (j + 1 < w) { v += m[i][j + 1].v; n++ }
            v = m[i][j].v - v / n
            d[i][j].v = v
            if (m[i][j].fixed == 0) total += v * v
        }
    }
    return total
}

fun iter(m: List2D<Node>, w: Int, h: Int): Double {
    val d = List(h) { List(w) { Node(0.0, 0) } }
    val cur = DoubleArray(3)
    var diff = 1e10

    while (diff > 1e-24) {
        setBoundary(m)
        diff = calcDiff(m, d, w, h)
        for (i in 0 until h) {
            for (j in 0 until w) m[i][j].v -= d[i][j].v
        }
    }

    for (i in 0 until h) {
        for (j in 0 until w) {
            var k = 0
            if (i != 0) k++
            if (j != 0) k++
            if (i < h - 1) k++
            if (j < w - 1) k++
            cur[m[i][j].fixed + 1] += d[i][j].v * k
        }
    }
    return (cur[2] - cur[0]) / 2.0
}

fun main(args: Array<String>) {
    val mesh = List(S) { List(S) { Node(0.0, 0) } }
    val r = 2.0 / iter(mesh, S, S)
    println("R = $r")
}
