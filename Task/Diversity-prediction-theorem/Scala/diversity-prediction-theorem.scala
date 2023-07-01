object DiversityPredictionTheorem {
  def square(d: Double): Double
  = d * d

  def average(a: Array[Double]): Double
  = a.sum / a.length

  def averageSquareDiff(d: Double, predictions: Array[Double]): Double
  = average(predictions.map(it => square(it - d)))

  def diversityTheorem(truth: Double, predictions: Array[Double]): String = {
    val avg = average(predictions)
    f"average-error : ${averageSquareDiff(truth, predictions)}%6.3f\n" +
    f"crowd-error   : ${square(truth - avg)}%6.3f\n"+
    f"diversity     : ${averageSquareDiff(avg, predictions)}%6.3f\n"
  }

  def main(args: Array[String]): Unit = {
    println(diversityTheorem(49.0, Array(48.0, 47.0, 51.0)))
    println(diversityTheorem(49.0, Array(48.0, 47.0, 51.0, 42.0)))
  }
}
