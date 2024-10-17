fun ffr(n: Int) = get(n, 0)[n - 1]

fun ffs(n: Int) = get(0, n)[n - 1]

internal fun get(rSize: Int, sSize: Int): List<Int> {
    val rlist = arrayListOf(1, 3, 7)
    val slist = arrayListOf(2, 4, 5, 6)
    val list = if (rSize > 0) rlist else slist
    val targetSize = if (rSize > 0) rSize else sSize

    while (list.size > targetSize)
        list.removeAt(list.size - 1)
    while (list.size < targetSize) {
        val lastIndex = rlist.lastIndex
        val lastr = rlist[lastIndex]
        val r = lastr + slist[lastIndex]
        rlist += r
        var s = lastr + 1
        while (s < r && list.size < targetSize)
            slist += s++
    }
    return list
}

fun main(args: Array<String>) {
    print("R():")
    (1..10).forEach { print(" " + ffr(it)) }
    println()

    val first40R = (1..40).map { ffr(it) }
    val first960S = (1..960).map { ffs(it) }
    val indices = (1..1000).filter  { it in first40R == it in first960S }
    indices.forEach { println("Integer $it either in both or neither set") }
    println("Done")
}
