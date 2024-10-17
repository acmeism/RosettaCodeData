fun turn(base: Int, n: Int): Int {
    var sum = 0
    var n2 = n
    while (n2 != 0) {
        val re = n2 % base
        n2 /= base
        sum += re
    }
    return sum % base
}

fun fairShare(base: Int, count: Int) {
    print(String.format("Base %2d:", base))
    for (i in 0 until count) {
        val t = turn(base, i)
        print(String.format(" %2d", t))
    }
    println()
}

fun turnCount(base: Int, count: Int) {
    val cnt = IntArray(base) { 0 }
    for (i in 0 until count) {
        val t = turn(base, i)
        cnt[t]++
    }

    var minTurn = Int.MAX_VALUE
    var maxTurn = Int.MIN_VALUE
    var portion = 0
    for (i in 0 until base) {
        val num = cnt[i]
        if (num > 0) {
            portion++
        }
        if (num < minTurn) {
            minTurn = num
        }
        if (num > maxTurn) {
            maxTurn = num
        }
    }

    print("  With $base people: ")
    when (minTurn) {
        0 -> {
            println("Only $portion have a turn")
        }
        maxTurn -> {
            println(minTurn)
        }
        else -> {
            println("$minTurn or $maxTurn")
        }
    }
}

fun main() {
    fairShare(2, 25)
    fairShare(3, 25)
    fairShare(5, 25)
    fairShare(11, 25)

    println("How many times does each get a turn in 50000 iterations?")
    turnCount(191, 50000)
    turnCount(1377, 50000)
    turnCount(49999, 50000)
    turnCount(50000, 50000)
    turnCount(50001, 50000)
}
