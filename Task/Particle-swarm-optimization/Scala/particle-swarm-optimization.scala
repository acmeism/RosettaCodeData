import scala.util.Random
import scala.math._

object PSO {
  case class Parameters(omega: Double, phip: Double, phig: Double)

  case class State(
    iter: Int,
    gbpos: Array[Double],
    gbval: Double,
    min: Array[Double],
    max: Array[Double],
    parameters: Parameters,
    pos: Array[Array[Double]],
    vel: Array[Array[Double]],
    bpos: Array[Array[Double]],
    bval: Array[Double],
    nParticles: Int,
    nDims: Int
  ) {
    def report(testFunc: String): Unit = {
      println(s"Test Function        : $testFunc")
      println(s"Iterations           : $iter")
      println(s"Global Best Position : ${gbpos.mkString("[", ", ", "]")}")
      println(f"Global Best value    : $gbval%.15f")
    }
  }

  private val random = new Random()

  def psoInit(min: Array[Double], max: Array[Double], parameters: Parameters, nParticles: Int): State = {
    val nDims = min.length
    val pos = Array.fill(nParticles)(min.clone())
    val vel = Array.fill(nParticles, nDims)(0.0)
    val bpos = Array.fill(nParticles)(min.clone())
    val bval = Array.fill(nParticles)(Double.PositiveInfinity)
    val iter = 0
    val gbpos = Array.fill(nDims)(Double.PositiveInfinity)
    val gbval = Double.PositiveInfinity

    State(iter, gbpos, gbval, min, max, parameters, pos, vel, bpos, bval, nParticles, nDims)
  }

  def pso(fn: Array[Double] => Double, y: State): State = {
    val p = y.parameters
    val v = Array.ofDim[Double](y.nParticles)
    val bpos = Array.fill(y.nParticles)(y.min.clone())
    val bval = Array.ofDim[Double](y.nParticles)
    var gbpos = Array.ofDim[Double](y.nDims)
    var gbval = Double.PositiveInfinity

    // Evaluate and update best positions
    for (j <- 0 until y.nParticles) {
      v(j) = fn(y.pos(j))

      if (v(j) < y.bval(j)) {
        bpos(j) = y.pos(j).clone()
        bval(j) = v(j)
      } else {
        bpos(j) = y.bpos(j).clone()
        bval(j) = y.bval(j)
      }

      if (bval(j) < gbval) {
        gbval = bval(j)
        gbpos = bpos(j).clone()
      }
    }

    val rg = random.nextDouble()
    val pos = Array.ofDim[Double](y.nParticles, y.nDims)
    val vel = Array.ofDim[Double](y.nParticles, y.nDims)

    // Update particle positions and velocities
    for (j <- 0 until y.nParticles) {
      val rp = random.nextDouble()
      var ok = true

      for (k <- 0 until y.nDims) {
        vel(j)(k) = p.omega * y.vel(j)(k) +
          p.phip * rp * (bpos(j)(k) - y.pos(j)(k)) +
          p.phig * rg * (gbpos(k) - y.pos(j)(k))
        pos(j)(k) = y.pos(j)(k) + vel(j)(k)
        ok = ok && y.min(k) < pos(j)(k) && y.max(k) > pos(j)(k)
      }

      if (!ok) {
        for (k <- 0 until y.nDims) {
          pos(j)(k) = y.min(k) + (y.max(k) - y.min(k)) * random.nextDouble()
        }
      }
    }

    val iter = y.iter + 1
    State(iter, gbpos, gbval, y.min, y.max, y.parameters, pos, vel, bpos, bval, y.nParticles, y.nDims)
  }

  def iterate(fn: Array[Double] => Double, n: Int, initialState: State): State = {
    if (n == Int.MaxValue) {
      // Infinite iteration until convergence
      var current = initialState
      var previous = initialState
      do {
        previous = current
        current = pso(fn, current)
      } while (current != previous)
      current
    } else {
      // Fixed number of iterations
      (0 until n).foldLeft(initialState)((state, _) => pso(fn, state))
    }
  }

  def mccormick(x: Array[Double]): Double = {
    val a = x(0)
    val b = x(1)
    sin(a + b) + (a - b) * (a - b) + 1.0 + 2.5 * b - 1.5 * a
  }

  def michalewicz(x: Array[Double]): Double = {
    val m = 10
    val d = x.length
    val sum = (1 until d).map { i =>
      val j = x(i - 1)
      val k = sin(i * j * j / Pi)
      sin(j) * pow(k, 2.0 * m)
    }.sum
    -sum
  }

  def main(args: Array[String]): Unit = {
    // Test McCormick function
    var state = psoInit(
      Array(-1.5, -3.0),
      Array(4.0, 4.0),
      Parameters(0.0, 0.6, 0.3),
      100
    )
    state = iterate(mccormick, 40, state)
    state.report("McCormick")
    println(f"f(-.54719, -1.54719) : ${mccormick(Array(-0.54719, -1.54719))}%.15f")
    println()

    // Test Michalewicz function
    state = psoInit(
      Array(0.0, 0.0),
      Array(Pi, Pi),
      Parameters(0.3, 3.0, 0.3),
      1000
    )
    state = iterate(michalewicz, 30, state)
    state.report("Michalewicz (2D)")
    println(f"f(2.20, 1.57)        : ${michalewicz(Array(2.20, 1.57))}%.15f")
  }
}
