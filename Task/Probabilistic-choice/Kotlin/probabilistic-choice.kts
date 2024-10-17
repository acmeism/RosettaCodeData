// version 1.0.6

fun main(args: Array<String>) {
    val letters  = arrayOf("aleph", "beth", "gimel", "daleth", "he", "waw", "zayin", "heth")
    val actual   = IntArray(8)
    val probs    = doubleArrayOf(1/5.0, 1/6.0, 1/7.0, 1/8.0, 1/9.0, 1/10.0, 1/11.0, 0.0)
    val cumProbs = DoubleArray(8)

    cumProbs[0] = probs[0]
    for (i in 1..6) cumProbs[i] = cumProbs[i - 1] + probs[i]
    cumProbs[7] = 1.0
    probs[7] = 1.0 - cumProbs[6]
    val n = 1000000
    (1..n).forEach {
        val rand = Math.random()
        when {
             rand <= cumProbs[0] -> actual[0]++
             rand <= cumProbs[1] -> actual[1]++
             rand <= cumProbs[2] -> actual[2]++
             rand <= cumProbs[3] -> actual[3]++
             rand <= cumProbs[4] -> actual[4]++
             rand <= cumProbs[5] -> actual[5]++
             rand <= cumProbs[6] -> actual[6]++
             else                -> actual[7]++
        }
    }

    var sumActual = 0.0
    println("Letter\t Actual    Expected")
    println("------\t--------   --------")
    for (i in 0..7) {
        val generated = actual[i].toDouble() / n
        println("${letters[i]}\t${String.format("%8.6f   %8.6f", generated, probs[i])}")
        sumActual += generated
    }
    println("\t--------   --------")
    println("\t${"%8.6f".format(sumActual)}   1.000000")
}
