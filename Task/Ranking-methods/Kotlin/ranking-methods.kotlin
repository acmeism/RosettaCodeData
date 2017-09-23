// version 1.0.6

/* all ranking functions assume the array of Pairs is non-empty and already sorted by decreasing order of scores
   and then, if the scores are equal, by reverse alphabetic order of names
*/

fun standardRanking(scores: Array<Pair<Int, String>>): IntArray {
    val rankings = IntArray(scores.size)
    rankings[0] = 1
    for (i in 1 until scores.size) rankings[i] = if (scores[i].first == scores[i - 1].first) rankings[i - 1] else i + 1
    return rankings
}

fun modifiedRanking(scores: Array<Pair<Int, String>>): IntArray {
    val rankings = IntArray(scores.size)
    rankings[0] = 1
    for (i in 1 until scores.size) {
        rankings[i] = i + 1
        val currScore = scores[i].first
        for (j in i - 1 downTo 0) {
            if (currScore != scores[j].first) break
            rankings[j] = i + 1
        }
    }
    return rankings
}

fun denseRanking(scores: Array<Pair<Int, String>>): IntArray {
    val rankings = IntArray(scores.size)
    rankings[0] = 1
    var prevRanking = 1
    for (i in 1 until scores.size) rankings[i] = if (scores[i].first == scores[i - 1].first) prevRanking else ++prevRanking
    return rankings
}

fun ordinalRanking(scores: Array<Pair<Int, String>>) = IntArray(scores.size) { it + 1 }

fun fractionalRanking(scores: Array<Pair<Int, String>>): DoubleArray {
    val rankings = DoubleArray(scores.size)
    rankings[0] = 1.0
    for (i in 1 until scores.size) {
        var k = i
        val currScore = scores[i].first
        for (j in i - 1 downTo 0) {
            if (currScore != scores[j].first) break
            k = j
        }
        val avg = (k..i).average() + 1.0
        for (m in k..i) rankings[m] = avg
    }
    return rankings
}

fun printRankings(title: String, rankings: IntArray, scores: Array<Pair<Int, String>>) {
    println(title + ":")
    for (i in 0 until rankings.size) {
        print ("${rankings[i]}  ")
        println(scores[i].toString().removeSurrounding("(", ")").replace(",", ""))
    }
    println()
}

fun printFractionalRankings(title: String, rankings: DoubleArray, scores: Array<Pair<Int, String>>) {
    println(title + ":")
    for (i in 0 until rankings.size) {
        print ("${"%3.2f".format(rankings[i])}  ")
        println(scores[i].toString().removeSurrounding("(", ")").replace(",", ""))
    }
    println()
}

fun main(args: Array<String>) {
    val scores = arrayOf(44 to "Solomon",  42 to "Jason", 42 to "Errol",  41 to "Garry",
                         41 to "Bernard",  41 to "Barry", 39 to "Stephen")
    printRankings("Standard ranking", standardRanking(scores), scores)
    printRankings("Modified ranking", modifiedRanking(scores), scores)
    printRankings("Dense ranking", denseRanking(scores), scores)
    printRankings("Ordinal ranking", ordinalRanking(scores), scores)
    printFractionalRankings("Fractional ranking", fractionalRanking(scores), scores)
}
