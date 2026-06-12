// version 1.1.3

import java.util.Random

fun equalBirthdays(nSharers: Int, groupSize: Int, nRepetitions: Int): Double {
    val rand = Random(1L)
    var eq = 0
    for (i in 0 until nRepetitions) {
        val group = IntArray(365)
        for (j in 0 until groupSize) {
            group[rand.nextInt(group.size)]++
        }
        eq += if (group.any { it >= nSharers}) 1 else 0
    }
    return eq * 100.0 / nRepetitions
}

fun main(args: Array<String>) {
    var groupEst = 2
    for (sharers in 2..5) {
        // Coarse
        var groupSize = groupEst + 1
        while (equalBirthdays(sharers, groupSize, 100) < 50.0) groupSize++

        // Finer
        val inf = (groupSize - (groupSize - groupEst) / 4.0).toInt()
        for (gs in inf until groupSize + 999) {
            val eq = equalBirthdays(sharers, groupSize, 250)
            if (eq > 50.0) {
                groupSize = gs
                break
            }
        }

        // Finest
        for (gs in groupSize - 1 until groupSize + 999) {
            val eq = equalBirthdays(sharers, gs, 50_000)
            if (eq > 50.0) {
                groupEst = gs
                print("$sharers independent people in a group of ${"%3d".format(gs)} ")
                println("share a common birthday (${"%2.1f%%".format(eq)})")
                break
            }
        }
    }
}
