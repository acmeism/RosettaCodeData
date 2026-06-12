object GradientDescent {

  /** Steepest descent method modifying input values*/
  def steepestDescent(x : Array[Double], learningRate : Double, tolerance : Double) = {
    val n = x.size
    var h = tolerance
    var alpha = learningRate
    var g0 = g(x) // Initial estimate of result.

    // Calculate initial gradient.
    var fi = gradG(x,h)

    // Calculate initial norm.
    var delG = 0.0
    for (i <- 0 until n by 1)  delG += fi(i) * fi(i)
    delG = math.sqrt(delG)
    var b = alpha / delG

    // Iterate until value is <= tolerance.
    while(delG > tolerance){
      // Calculate next value.
      for (i <- 0 until n by 1) x(i) -= b * fi(i)
      h /= 2

      // Calculate next gradient.
      fi = gradG(x,h)

      // Calculate next norm.
      delG = 0.0
      for (i <- 0 until n by 1) delG += fi(i) * fi(i)
      delG = math.sqrt(delG)
      b = alpha / delG

      // Calculate next value.
      var g1 = g(x)

      // Adjust parameter.
      if(g1 > g0) alpha = alpha / 2
      else g0 = g1
    }

  }

  /** Gradient of the input function given in the task*/
  def gradG(x : Array[Double], h : Double) : Array[Double] = {
    val n = x.size
    val z : Array[Double] = Array.fill(n){0}
    val y = x
    val g0 = g(x)

    for(i <- 0 until n by 1){
      y(i) += h
      z(i) = (g(y) - g0) / h
    }

    z

  }

  /** Bivariate function given in the task*/
  def g( x : Array[Double]) : Double = {
    ( (x(0)-1) * (x(0)-1) * math.exp( -x(1)*x(1) ) + x(1) * (x(1)+2) * math.exp( -2*x(0)*x(0) ) )
  }

  def main(args: Array[String]): Unit = {
    val tolerance = 0.0000006
    val learningRate = 0.1
    val x =  Array(0.1, -1) // Initial guess of location of minimum.

    steepestDescent(x, learningRate, tolerance)
    println("Testing steepest descent method")
    println("The minimum is at x : " + x(0) + ", y : " + x(1))
  }
}
