fun main() {
    println("First 30 values in the yellowstone sequence:")
    println(yellowstoneSequence(30))
}

private fun yellowstoneSequence(sequenceCount: Int): List<Int> {
    val yellowstoneList = mutableListOf(1, 2, 3)
    var num = 4
    val notYellowstoneList = mutableListOf<Int>()
    var yellowSize = 3
    while (yellowSize < sequenceCount) {
        var found = -1
        for (index in notYellowstoneList.indices) {
            val test = notYellowstoneList[index]
            if (gcd(yellowstoneList[yellowSize - 2], test) > 1 && gcd(
                    yellowstoneList[yellowSize - 1], test
                ) == 1
            ) {
                found = index
                break
            }
        }
        if (found >= 0) {
            yellowstoneList.add(notYellowstoneList.removeAt(found))
            yellowSize++
        } else {
            while (true) {
                if (gcd(yellowstoneList[yellowSize - 2], num) > 1 && gcd(
                        yellowstoneList[yellowSize - 1], num
                    ) == 1
                ) {
                    yellowstoneList.add(num)
                    yellowSize++
                    num++
                    break
                }
                notYellowstoneList.add(num)
                num++
            }
        }
    }
    return yellowstoneList
}

private fun gcd(a: Int, b: Int): Int {
    return if (b == 0) {
        a
    } else gcd(b, a % b)
}
