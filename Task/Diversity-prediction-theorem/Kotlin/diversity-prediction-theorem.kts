// version 1.1.4-3

fun square(d: Double) = d * d

fun averageSquareDiff(d: Double, predictions: DoubleArray) =
    predictions.map { square(it - d) }.average()

fun diversityTheorem(truth: Double, predictions: DoubleArray): String {
    val average = predictions.average()
    val f = "%6.3f"
    return "average-error : ${f.format(averageSquareDiff(truth, predictions))}\n" +
           "crowd-error   : ${f.format(square(truth - average))}\n" +
           "diversity     : ${f.format(averageSquareDiff(average, predictions))}\n"
}

fun main(args: Array<String>) {
    println(diversityTheorem(49.0, doubleArrayOf(48.0, 47.0, 51.0)))
    println(diversityTheorem(49.0, doubleArrayOf(48.0, 47.0, 51.0, 42.0)))
}
