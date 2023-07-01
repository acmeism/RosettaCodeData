// version 1.1.3

fun nextPerm(perm: IntArray): Boolean {
    val size = perm.size
    var k = -1
    for (i in size - 2 downTo 0) {
        if (perm[i] < perm[i + 1]) {
            k = i
            break
        }
    }
    if (k == -1) return false  // last permutation
    for (l in size - 1 downTo k) {
        if (perm[k] < perm[l]) {
           val temp = perm[k]
           perm[k] = perm[l]
           perm[l] = temp
           var m = k + 1
           var n = size - 1
           while (m < n) {
               val temp2 = perm[m]
               perm[m++] = perm[n]
               perm[n--] = temp2
           }
           break
        }
    }
    return true
}

fun List<Int>.isMonotonic(): Boolean {
    for (i in 1 until this.size) {
        if (this[i] < this[i - 1]) return false
    }
    return true
}

fun main(args: Array<String>) {
    val sizes = args.map { it.toInt() }
    println("Partitions for $sizes:\n[")
    val totalSize = sizes.sum()
    val perm = IntArray(totalSize) { it + 1 }

    do {
        val partition = mutableListOf<List<Int>>()
        var sum = 0
        var isValid = true
        for (size in sizes) {
            if (size == 0) {
                partition.add(emptyList<Int>())
            }
            else if (size == 1) {
                partition.add(listOf(perm[sum]))
            }
            else {
                val sl = perm.slice(sum until sum + size)
                if (!sl.isMonotonic()) {
                    isValid = false
                    break
                }
                partition.add(sl)
            }
            sum += size
        }
        if (isValid) println("  $partition")
    }
    while (nextPerm(perm))
    println("]")
}
