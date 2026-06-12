// version 1.1.2

fun main(args: Array<String>) {
    val n  = 3
    val values = charArrayOf('A', 'B', 'C', 'D')
    val k = values.size
    // terminate when first two characters of the permutation are 'B' and 'C' respectively
    val decide = fun(pc: CharArray) = pc[0] == 'B' && pc[1] == 'C'
    val pn = IntArray(n)
    val pc = CharArray(n)
    while (true) {
        // generate permutation
        for ((i, x) in pn.withIndex()) pc[i] = values[x]
        // show progress
        println(pc.contentToString())
        // pass to deciding function
        if (decide(pc)) return  // terminate early
        // increment permutation number
        var i = 0
        while (true) {
            pn[i]++
            if (pn[i] < k) break
            pn[i++] = 0
            if (i == n) return  // all permutations generated
        }
    }
}
