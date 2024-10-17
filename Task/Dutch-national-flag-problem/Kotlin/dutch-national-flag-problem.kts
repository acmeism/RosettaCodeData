// version 1.1.4

import java.util.Random

enum class DutchColors { RED, WHITE, BLUE }

fun Array<DutchColors>.swap(i: Int, j: Int) {
    val temp = this[i]
    this[i] = this[j]
    this[j] = temp
}

fun Array<DutchColors>.sort() {
    var lo = 0
    var mid = 0
    var hi = this.lastIndex

    while (mid <= hi) {
        when (this[mid]) {
            DutchColors.RED   -> this.swap(lo++, mid++)
            DutchColors.WHITE -> mid++
            DutchColors.BLUE  -> this.swap(mid, hi--)
        }
    }
}

fun Array<DutchColors>.isSorted(): Boolean {
    return (1 until this.size)
        .none { this[it].ordinal < this[it - 1].ordinal }
}

const val NUM_BALLS = 9

fun main(args: Array<String>) {
    val r = Random()
    val balls  = Array(NUM_BALLS) { DutchColors.RED }
    val colors = DutchColors.values()

    // give balls random colors whilst ensuring they're not already sorted
    do {
        for (i in 0 until NUM_BALLS) balls[i] = colors[r.nextInt(3)]
    }
    while (balls.isSorted())

    // print the colors of the balls before sorting
    println("Before sorting : ${balls.contentToString()}")

    // sort the balls in DutchColors order
    balls.sort()

    // print the colors of the balls after sorting
    println("After sorting  : ${balls.contentToString()}")
}
