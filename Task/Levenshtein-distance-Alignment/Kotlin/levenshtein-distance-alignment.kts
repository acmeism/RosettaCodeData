// version 1.1.3

fun levenshteinAlign(a: String, b: String): Array<String> {
    val aa = a.toLowerCase()
    val bb = b.toLowerCase()
    val costs = Array(a.length + 1) { IntArray(b.length + 1) }
    for (j in 0..b.length) costs[0][j] = j
    for (i in 1..a.length) {
        costs[i][0] = i
        for (j in 1..b.length) {
            val temp = costs[i - 1][j - 1] + (if (aa[i - 1] == bb[j - 1]) 0 else 1)
            costs[i][j] = minOf(1 + minOf(costs[i - 1][j], costs[i][j - 1]), temp)
        }
    }

    // walk back through matrix to figure out path
    val aPathRev = StringBuilder()
    val bPathRev = StringBuilder()
    var i = a.length
    var j = b.length
    while (i != 0 && j != 0) {
        val temp = costs[i - 1][j - 1] + (if (aa[i - 1] == bb[j - 1]) 0 else 1)
        when (costs[i][j]) {
            temp -> {
                aPathRev.append(aa[--i])
                bPathRev.append(bb[--j])
            }

            1 + costs[i-1][j] -> {
                aPathRev.append(aa[--i])
                bPathRev.append('-')
            }

            1 + costs[i][j-1] -> {
                aPathRev.append('-')
                bPathRev.append(bb[--j])
            }
        }
    }
    return arrayOf(aPathRev.reverse().toString(), bPathRev.reverse().toString())
}

fun main(args: Array<String>) {
    var result = levenshteinAlign("place", "palace")
    println(result[0])
    println(result[1])
    println()
    result = levenshteinAlign("rosettacode","raisethysword")
    println(result[0])
    println(result[1])
}
