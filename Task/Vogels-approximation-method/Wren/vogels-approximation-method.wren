import "./math" for Nums
import "./fmt" for Fmt

var supply = [50, 60, 50, 50]
var demand = [30, 20, 70, 30, 60]

var costs = [
    [16, 16, 13, 22, 17],
    [14, 14, 13, 19, 15],
    [19, 19, 20, 23, 50],
    [50, 12, 50, 15, 11]
]

var nRows = supply.count
var nCols = demand.count

var rowDone = List.filled(nRows, false)
var colDone = List.filled(nCols, false)
var results = List.filled(nRows, null)
for (i in 0...nRows) results[i] = List.filled(nCols, 0)

var diff = Fn.new { |j, len, isRow|
    var min1 = Num.maxSafeInteger
    var min2 = min1
    var minP = -1
    for (i in 0...len) {
        var done = isRow ? colDone[i] : rowDone[i]
        if (!done) {
            var c = isRow ? costs[j][i] : costs[i][j]
            if (c < min1) {
                min2 = min1
                min1 = c
                minP = i
            } else if (c < min2) min2 = c
        }
    }
    return [min2 - min1, min1, minP]
}

var maxPenalty = Fn.new { |len1, len2, isRow|
    var md = Num.minSafeInteger
    var pc = -1
    var pm = -1
    var mc = -1
    for (i in 0...len1) {
        var done = isRow ? rowDone[i] : colDone[i]
        if (!done) {
            var res = diff.call(i, len2, isRow)
            if (res[0] > md) {
                md = res[0]  // max diff
                pm = i       // pos of max diff
                mc = res[1]  // min cost
                pc = res[2]  // pos of min cost
            }
        }
    }
    return isRow ? [pm, pc, mc, md] : [pc, pm, mc, md]
}

var nextCell = Fn.new {
    var res1 = maxPenalty.call(nRows, nCols, true)
    var res2 = maxPenalty.call(nCols, nRows, false)
    if (res1[3] == res2[3]) return (res1[2] < res2[2]) ? res1 : res2
    return (res1[3] > res2[3]) ? res2 : res1
}

var supplyLeft = Nums.sum(supply)
var totalCost = 0
while (supplyLeft > 0) {
    var cell = nextCell.call()
    var r = cell[0]
    var c = cell[1]
    var q = demand[c].min(supply[r])
    demand[c] = demand[c] - q
    if (demand[c] == 0) colDone[c] = true
    supply[r] = supply[r] - q
    if (supply[r] == 0) rowDone[r] = true
    results[r][c] = q
    supplyLeft = supplyLeft - q
    totalCost = totalCost + q*costs[r][c]
}

System.print("    A   B   C   D   E")
var i = 0
for (result in results) {
    Fmt.write("$c", "W".bytes[0] + i)
    for (item in result) Fmt.write("  $2d", item)
    System.print()
    i = i + 1
}
System.print("\nTotal Cost = %(totalCost)")
