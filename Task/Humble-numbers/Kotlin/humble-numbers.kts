fun isHumble(i: Int): Boolean {
    if (i <= 1) return true
    if (i % 2 == 0) return isHumble(i / 2)
    if (i % 3 == 0) return isHumble(i / 3)
    if (i % 5 == 0) return isHumble(i / 5)
    if (i % 7 == 0) return isHumble(i / 7)
    return false
}

fun main() {
    val limit: Int = Short.MAX_VALUE.toInt()
    val humble = mutableMapOf<Int, Int>()
    var count = 0
    var num = 1

    while (count < limit) {
        if (isHumble(num)) {
            val str = num.toString()
            val len = str.length
            humble.merge(len, 1) { a, b -> a + b }

            if (count < 50) print("$num ")
            count++
        }
        num++
    }
    println("\n")

    println("Of the first $count humble numbers:")
    num = 1
    while (num < humble.size - 1) {
        if (humble.containsKey(num)) {
            val c = humble[num]
            println("%5d have %2d digits".format(c, num))
            num++
        } else {
            break
        }
    }
}
