// version 1.2.0

import java.util.BitSet

typealias BitSets = List<MutableList<BitSet>>

val rx = Regex("""\s""")

fun newPuzzle(data: List<String>) {
    val rowData = data[0].split(rx)
    val colData = data[1].split(rx)
    val rows = getCandidates(rowData, colData.size)
    val cols = getCandidates(colData, rowData.size)

    do {
        val numChanged = reduceMutual(cols, rows)
        if (numChanged == -1) {
            println("No solution")
            return
        }
    }
    while (numChanged > 0)

    for (row in rows) {
        for (i in 0 until cols.size) {
            print(if (row[0][i]) "# " else ". ")
        }
        println()
    }
    println()
}

// collect all possible solutions for the given clues
fun getCandidates(data: List<String>, len: Int): BitSets {
    val result = mutableListOf<MutableList<BitSet>>()
    for (s in data) {
        val lst = mutableListOf<BitSet>()
        val a = s.toCharArray()
        val sumChars = a.sumBy { it - 'A' + 1 }
        val prep = a.map { "1".repeat(it - 'A' + 1) }

        for (r in genSequence(prep, len - sumChars + 1)) {
            val bits = r.substring(1).toCharArray()
            val bitset = BitSet(bits.size)
            for (i in 0 until bits.size) bitset[i] = bits[i] == '1'
            lst.add(bitset)
        }
        result.add(lst)
    }
    return result
}

fun genSequence(ones: List<String>, numZeros: Int): List<String> {
    if (ones.isEmpty()) return listOf("0".repeat(numZeros))
    val result = mutableListOf<String>()
    for (x in 1 until numZeros - ones.size + 2) {
        val skipOne = ones.drop(1)
        for (tail in genSequence(skipOne, numZeros - x)) {
            result.add("0".repeat(x) + ones[0] + tail)
        }
    }
    return result
}

/* If all the candidates for a row have a value in common for a certain cell,
    then it's the only possible outcome, and all the candidates from the
    corresponding column need to have that value for that cell too. The ones
    that don't, are removed. The same for all columns. It goes back and forth,
    until no more candidates can be removed or a list is empty (failure).
*/

fun reduceMutual(cols: BitSets, rows: BitSets): Int {
    val countRemoved1 = reduce(cols, rows)
    if (countRemoved1 == -1) return -1
    val countRemoved2 = reduce(rows, cols)
    if (countRemoved2 == -1) return -1
    return countRemoved1 + countRemoved2
}

fun reduce(a: BitSets, b: BitSets): Int {
    var countRemoved = 0
    for (i in 0 until a.size) {
        val commonOn = BitSet()
        commonOn[0] = b.size
        val commonOff = BitSet()

        // determine which values all candidates of a[i] have in common
        for (candidate in a[i]) {
            commonOn.and(candidate)
            commonOff.or(candidate)
        }

        // remove from b[j] all candidates that don't share the forced values
        for (j in 0 until b.size) {
            val fi = i
            val fj = j
            if (b[j].removeIf { cnd ->
                (commonOn[fj] && !cnd[fi]) ||
                (!commonOff[fj] && cnd[fi]) }) countRemoved++
            if (b[j].isEmpty()) return -1
        }
    }
    return countRemoved
}

val p1 = listOf("C BA CB BB F AE F A B", "AB CA AE GA E C D C")

val p2 = listOf(
    "F CAC ACAC CN AAA AABB EBB EAA ECCC HCCC",
    "D D AE CD AE A DA BBB CC AAB BAA AAB DA AAB AAA BAB AAA CD BBA DA"
)

val p3 = listOf(
    "CA BDA ACC BD CCAC CBBAC BBBBB BAABAA ABAD AABB BBH " +
    "BBBD ABBAAA CCEA AACAAB BCACC ACBH DCH ADBE ADBB DBE ECE DAA DB CC",
    "BC CAC CBAB BDD CDBDE BEBDF ADCDFA DCCFB DBCFC ABDBA BBF AAF BADB DBF " +
    "AAAAD BDG CEF CBDB BBB FC"
)

val p4 = listOf(
    "E BCB BEA BH BEK AABAF ABAC BAA BFB OD JH BADCF Q Q R AN AAN EI H G",
    "E CB BAB AAA AAA AC BB ACC ACCA AGB AIA AJ AJ " +
    "ACE AH BAF CAG DAG FAH FJ GJ ADK ABK BL CM"
)

fun main(args: Array<String>) {
    for (puzzleData in listOf(p1, p2, p3, p4)) {
        newPuzzle(puzzleData)
    }
}
