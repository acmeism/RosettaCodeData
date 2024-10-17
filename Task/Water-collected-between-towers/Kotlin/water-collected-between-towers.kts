// version 1.1.2

fun waterCollected(tower: IntArray): Int {
    val n = tower.size
    val highLeft = listOf(0) + (1 until n).map { tower.slice(0 until it).max()!! }
    val highRight = (1 until n).map { tower.slice(it until n).max()!! } + 0
    return (0 until n).map { maxOf(minOf(highLeft[it], highRight[it]) - tower[it], 0) }.sum()
}

fun main(args: Array<String>) {
    val towers = listOf(
        intArrayOf(1, 5, 3, 7, 2),
        intArrayOf(5, 3, 7, 2, 6, 4, 5, 9, 1, 2),
        intArrayOf(2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1),
        intArrayOf(5, 5, 5, 5),
        intArrayOf(5, 6, 7, 8),
        intArrayOf(8, 7, 7, 6),
        intArrayOf(6, 7, 10, 7, 6)
    )
    for (tower in towers) {
        println("${"%2d".format(waterCollected(tower))} from ${tower.contentToString()}")
    }
}
