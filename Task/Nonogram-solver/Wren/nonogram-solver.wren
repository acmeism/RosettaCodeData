import "/pattern" for Pattern
import "/math" for Nums, Boolean
import "/fmt" for Conv

var p = Pattern.new("/s")

var genSequence // recursive
genSequence = Fn.new { |ones, numZeros|
    if (ones.isEmpty) return ["0" * numZeros]
    var result = []
    var x = 1
    while (x < numZeros - ones.count + 2) {
        var skipOne = ones.skip(1).toList
        for (tail in genSequence.call(skipOne, numZeros - x)) {
            result.add("0" * x + ones[0] + tail)
        }
        x = x + 1
    }
    return result
}

/* If all the candidates for a row have a value in common for a certain cell,
    then it's the only possible outcome, and all the candidates from the
    corresponding column need to have that value for that cell too. The ones
    that don't, are removed. The same for all columns. It goes back and forth,
    until no more candidates can be removed or a list is empty (failure).
*/
var reduce =  Fn.new { |a, b|
    var countRemoved = 0
    for (i in 0...a.count) {
        var commonOn  = List.filled(b.count, true)
        var commonOff = List.filled(b.count, false)

        // determine which values all candidates of a[i] have in common
        for (candidate in a[i]) {
            for (i in 0...b.count) {
                commonOn[i]  = Boolean.and(commonOn[i], candidate[i])
                commonOff[i] = Boolean.or(commonOff[i], candidate[i])
            }
        }

        // remove from b[j] all candidates that don't share the forced values
        for (j in 0...b.count) {
            var fi = i
            var fj = j
            var removals = false
            b[j].each { |cnd|
                if ((commonOn[fj] && !cnd[fi]) || (!commonOff[fj] && cnd[fi])) {
                    b[j].remove(cnd)
                    removals = true
                }
            }
            if (removals) countRemoved = countRemoved + 1
            if (b[j].isEmpty) return -1
        }
    }
    return countRemoved
}

var reduceMutual = Fn.new { |cols, rows|
    var countRemoved1 = reduce.call(cols, rows)
    if (countRemoved1 == -1) return -1
    var countRemoved2 = reduce.call(rows, cols)
    if (countRemoved2 == -1) return -1
    return countRemoved1 + countRemoved2
}

// collect all possible solutions for the given clues
var getCandidates = Fn.new { |data, len|
    var result = []
    for (s in data) {
        var lst = []
        var a = s.bytes
        var sumChars = Nums.sum(a.map { |b| b - 64 })
        var prep = a.map { |b| "1" * (b - 64) }.toList

        for (r in genSequence.call(prep, len - sumChars + 1)) {
            var bits = r[1..-1].bytes
            var len = bits.count
            if (len % 64 != 0) len = (len/64).ceil * 64
            var bitset = List.filled(len, false)
            for (i in 0...bits.count.min(bitset.count)) bitset[i] = bits[i] == 49
            lst.add(bitset)
        }
        result.add(lst)
    }
    return result
}

var newPuzzle = Fn.new { |data|
    var rowData = p.splitAll(data[0])
    var colData = p.splitAll(data[1])
    var rows = getCandidates.call(rowData, colData.count)
    var cols = getCandidates.call(colData, rowData.count)

    while (true) {
        var numChanged = reduceMutual.call(cols, rows)
        if (numChanged == -1) {
            System.print("No solution")
            return
        }
        if (numChanged <= 0) break
    }

    for (row in rows) {
        for (i in 0...cols.count) {
            System.write(row[0][i] ? "# " : ". ")
        }
        System.print()
    }
    System.print()
}

var p1 = ["C BA CB BB F AE F A B", "AB CA AE GA E C D C"]

var p2 = [
    "F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
    "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA"
]

var p3 = [
    "CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH " +
    "BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
    "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF " +
    "AAAAD BDG CEF CBDB BBB FC"
]

var p4 = [
    "E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
    "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ " +
    "ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM"
]

for (puzzleData in [p1, p2, p3, p4]) newPuzzle.call(puzzleData)
