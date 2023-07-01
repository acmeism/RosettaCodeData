// version 1.1.2

fun <T : Comparable<T>> patienceSort(arr: Array<T>) {
    if (arr.size < 2) return
    val piles = mutableListOf<MutableList<T>>()
    outer@ for (el in arr) {
        for (pile in piles) {
            if (pile.last() > el) {
                pile.add(el)
                continue@outer
            }
        }
        piles.add(mutableListOf(el))
    }

    for (i in 0 until arr.size) {
        var min = piles[0].last()
        var minPileIndex = 0
        for (j in 1 until piles.size) {
            if (piles[j].last() < min) {
                min = piles[j].last()
                minPileIndex = j
            }
        }
        arr[i] = min
        val minPile = piles[minPileIndex]
        minPile.removeAt(minPile.lastIndex)
        if (minPile.size == 0) piles.removeAt(minPileIndex)
    }
}

fun main(args: Array<String>) {
    val iArr = arrayOf(4, 65, 2, -31, 0, 99, 83, 782, 1)
    patienceSort(iArr)
    println(iArr.contentToString())
    val cArr = arrayOf('n', 'o', 'n', 'z', 'e', 'r', 'o', 's', 'u','m')
    patienceSort(cArr)
    println(cArr.contentToString())
    val sArr = arrayOf("dog", "cow", "cat", "ape", "ant", "man", "pig", "ass", "gnu")
    patienceSort(sArr)
    println(sArr.contentToString())
}
