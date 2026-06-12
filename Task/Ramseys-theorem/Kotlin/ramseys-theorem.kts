// version 1.1.0

val a = Array(17) { IntArray(17) }
val idx = IntArray(4)

fun findGroup(type: Int, minN: Int, maxN: Int, depth: Int): Boolean {
    if (depth == 4) {
        print("\nTotally ${if (type != 0) "" else "un"}connected group:")
        for (i in 0 until 4) print(" ${idx[i]}")
        println()
        return true
    }

    for (i in minN until maxN) {
        var n = depth
        for (m in 0 until depth) if (a[idx[m]][i] != type) {
            n = m
            break
        }
        if (n == depth) {
            idx[n] = i
            if (findGroup(type, 1, maxN, depth + 1)) return true
        }
    }
    return false
}

fun main(args: Array<String>) {
    for (i in 0 until 17) a[i][i] = 2
    var j: Int
    var k = 1
    while (k <= 8) {
        for (i in 0 until 17) {
            j = (i + k) % 17
            a[i][j] = 1
            a[j][i] = 1
        }
        k = k shl 1
    }
    val mark = "01-"
    for (i in 0 until 17) {
        for (m in 0 until 17) print("${mark[a[i][m]]} ")
        println()
    }
    for (i in 0 until 17) {
        idx[0] = i
        if (findGroup(1, i + 1, 17, 1) || findGroup(0, i + 1, 17, 1)) {
            println("\nRamsey condition not satisfied.")
            return
        }
    }
    println("\nRamsey condition satisfied.")
}
