// version 1.1.3

val supply = intArrayOf(50, 60, 50, 50)
val demand = intArrayOf(30, 20, 70, 30, 60)

val costs = arrayOf(
    intArrayOf(16, 16, 13, 22, 17),
    intArrayOf(14, 14, 13, 19, 15),
    intArrayOf(19, 19, 20, 23, 50),
    intArrayOf(50, 12, 50, 15, 11)
)

val nRows = supply.size
val nCols = demand.size

val rowDone = BooleanArray(nRows)
val colDone = BooleanArray(nCols)
val results = Array(nRows) { IntArray(nCols) }

fun nextCell(): IntArray {
    val res1 = maxPenalty(nRows, nCols, true)
    val res2 = maxPenalty(nCols, nRows, false)
    if (res1[3] == res2[3])
        return if (res1[2] < res2[2]) res1 else res2
    return if (res1[3] > res2[3]) res2 else res1
}

fun diff(j: Int, len: Int, isRow: Boolean): IntArray {
    var min1 = Int.MAX_VALUE
    var min2 = min1
    var minP = -1
    for (i in 0 until len) {
        val done = if (isRow) colDone[i] else rowDone[i]
        if (done) continue
        val c = if (isRow) costs[j][i] else costs[i][j]
        if (c < min1) {
            min2 = min1
            min1 = c
            minP = i
        }
        else if (c < min2) min2 = c
    }
    return intArrayOf(min2 - min1, min1, minP)
}

fun maxPenalty(len1: Int, len2: Int, isRow: Boolean): IntArray {
    var md = Int.MIN_VALUE
    var pc = -1
    var pm = -1
    var mc = -1
    for (i in 0 until len1) {
        val done = if (isRow) rowDone[i] else colDone[i]
        if (done) continue
        val res = diff(i, len2, isRow)
        if (res[0] > md) {
            md = res[0]  // max diff
            pm = i       // pos of max diff
            mc = res[1]  // min cost
            pc = res[2]  // pos of min cost
        }
    }
    return if (isRow) intArrayOf(pm, pc, mc, md) else
                      intArrayOf(pc, pm, mc, md)
}

fun main(args: Array<String>) {
    var supplyLeft = supply.sum()
    var totalCost = 0
    while (supplyLeft > 0) {
        val cell = nextCell()
        val r = cell[0]
        val c = cell[1]
        val q = minOf(demand[c], supply[r])
        demand[c] -= q
        if (demand[c] == 0) colDone[c] = true
        supply[r] -= q
        if (supply[r] == 0) rowDone[r] = true
        results[r][c] = q
        supplyLeft -= q
        totalCost += q * costs[r][c]
    }

    println("    A   B   C   D   E")
    for ((i, result) in results.withIndex()) {
        print(('W'.toInt() + i).toChar())
        for (item in result) print("  %2d".format(item))
        println()
    }
    println("\nTotal Cost = $totalCost")
}
