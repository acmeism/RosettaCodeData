// version 1.1.51

var example: List<Int>? = null

fun checkSeq(pos: Int, seq: List<Int>, n: Int, minLen: Int): Pair<Int, Int> =
    if (pos > minLen || seq[0] > n) minLen to 0
    else if (seq[0] == n)           { example = seq; pos to 1 }
    else if (pos < minLen)          tryPerm(0, pos, seq, n, minLen)
    else                            minLen to 0

fun tryPerm(i: Int, pos: Int, seq: List<Int>, n: Int, minLen: Int): Pair<Int, Int> {
    if (i > pos) return minLen to 0
    val res1 = checkSeq(pos + 1, listOf(seq[0] + seq[i]) + seq, n, minLen)
    val res2 = tryPerm(i + 1, pos, seq, n, res1.first)
    return if (res2.first < res1.first)       res2
           else if (res2.first == res1.first) res2.first to (res1.second + res2.second)
           else                               { println("Exception in tryPerm"); 0 to 0 }
}

fun initTryPerm(x: Int, minLen: Int) = tryPerm(0, 0, listOf(1), x, minLen)

fun findBrauer(num: Int, minLen: Int, nbLimit: Int) {
    val (actualMin, brauer) = initTryPerm(num, minLen)
    println("\nN = $num")
    println("Minimum length of chains : L($num) = $actualMin")
    println("Number of minimum length Brauer chains : $brauer")
    if (brauer > 0) println("Brauer example : ${example!!.reversed()}")
    example = null
    if (num <= nbLimit) {
        val nonBrauer = findNonBrauer(num, actualMin + 1, brauer)
        println("Number of minimum length non-Brauer chains : $nonBrauer")
        if (nonBrauer > 0) println("Non-Brauer example : ${example!!}")
        example = null
    }
    else {
        println("Non-Brauer analysis suppressed")
    }
}

fun isAdditionChain(a: IntArray): Boolean {
    for (i in 2 until a.size) {
        if (a[i] > a[i - 1] * 2) return false
        var ok = false
        jloop@ for (j in i - 1 downTo 0) {
            for (k in j downTo 0) {
               if (a[j] + a[k] == a[i]) { ok = true; break@jloop }
            }
        }
        if (!ok) return false
    }
    if (example == null && !isBrauer(a)) example = a.toList()
    return true
}

fun isBrauer(a: IntArray): Boolean {
    for (i in 2 until a.size) {
        var ok = false
        for (j in i - 1 downTo 0) {
            if (a[i - 1] + a[j] == a[i]) { ok = true; break }
        }
        if (!ok) return false
    }
    return true
}

fun findNonBrauer(num: Int, len: Int, brauer: Int): Int {
    val seq = IntArray(len)
    seq[0] = 1
    seq[len - 1] = num
    for (i in 1 until len - 1) seq[i] = seq[i - 1] + 1
    var count = if (isAdditionChain(seq)) 1 else 0

    fun nextChains(index: Int) {
        while (true) {
            if (index < len - 1) nextChains(index + 1)
            if (seq[index] + len - 1 - index >= seq[len - 1]) return
            seq[index]++
            for (i in index + 1 until len - 1) seq[i] = seq[i - 1] + 1
            if (isAdditionChain(seq)) count++
        }
    }

    nextChains(2)
    return count - brauer
}

fun main(args: Array<String>) {
    val nums = listOf(7, 14, 21, 29, 32, 42, 64, 47, 79, 191, 382, 379)
    println("Searching for Brauer chains up to a minimum length of 12:")
    for (num in nums) findBrauer(num, 12, 79)
}
