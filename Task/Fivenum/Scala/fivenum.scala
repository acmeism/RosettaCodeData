import java.util

object Fivenum extends App {

  val xl = Array(
    Array(15.0, 6.0, 42.0, 41.0, 7.0, 36.0, 49.0, 40.0, 39.0, 47.0, 43.0),
    Array(36.0, 40.0, 7.0, 39.0, 41.0, 15.0),
    Array(0.14082834, 0.09748790, 1.73131507, 0.87636009, -1.95059594, 0.73438555,
      -0.03035726, 1.46675970, -0.74621349, -0.72588772, 0.63905160, 0.61501527, -0.98983780,
      -1.00447874, -0.62759469, 0.66206163, 1.04312009, -0.10305385, 0.75775634, 0.32566578)
  )

  for (x <- xl) println(f"${util.Arrays.toString(fivenum(x))}%s\n\n")

  def fivenum(x: Array[Double]): Array[Double] = {
    require(x.forall(!_.isNaN), "Unable to deal with arrays containing NaN")

    def median(x: Array[Double], start: Int, endInclusive: Int): Double = {
      val size = endInclusive - start + 1
      require(size > 0, "Array slice cannot be empty")
      val m = start + size / 2
      if (size % 2 == 1) x(m) else (x(m - 1) + x(m)) / 2.0
    }

    val result = new Array[Double](5)
    util.Arrays.sort(x)
    result(0) = x(0)
    result(2) = median(x, 0, x.length - 1)
    result(4) = x(x.length - 1)
    val m = x.length / 2
    val lowerEnd = if (x.length % 2 == 1) m else m - 1
    result(1) = median(x, 0, lowerEnd)
    result(3) = median(x, m, x.length - 1)
    result
  }

}
