import scala.util.Random
import scala.math._

object SimulatedAnnealingTSP {

  private val dists: Array[Double] = calcDists()
  private val dirs: Array[Int] = Array(1, -1, 10, -10, 9, 11, -11, -9) // all 8 neighbors
  private val rand = new Random()

  // Calculate distances lookup table
  private def calcDists(): Array[Double] = {
    val dists = new Array[Double](10000)
    for (i <- 0 until 10000) {
      val ab = floor(i / 100.0)
      val cd = i % 100
      val a = floor(ab / 10)
      val b = ab.toInt % 10
      val c = floor(cd / 10)
      val d = cd % 10
      dists(i) = hypot(a - c, b - d)
    }
    dists
  }

  // Index into lookup table of doubles
  private def dist(ci: Int, cj: Int): Double = dists(cj * 100 + ci)

  // Energy at s, to be minimized
  private def Es(path: Array[Int]): Double = {
    (0 until path.length - 1).map(i => dist(path(i), path(i + 1))).sum
  }

  // Temperature function, decreases to 0
  private def T(k: Int, kmax: Int, kT: Int): Double = {
    (1 - k.toDouble / kmax) * kT
  }

  // Variation of E, from state s to state s_next
  private def dE(s: Array[Int], u: Int, v: Int): Double = {
    val su = s(u)
    val sv = s(v)

    // Old distances
    val a = dist(s(u - 1), su)
    val b = dist(s(u + 1), su)
    val c = dist(s(v - 1), sv)
    val d = dist(s(v + 1), sv)

    // New distances
    val na = dist(s(u - 1), sv)
    val nb = dist(s(u + 1), sv)
    val nc = dist(s(v - 1), su)
    val nd = dist(s(v + 1), su)

    if (v == u + 1) {
      (na + nd) - (a + d)
    } else if (u == v + 1) {
      (nc + nb) - (c + b)
    } else {
      (na + nb + nc + nd) - (a + b + c + d)
    }
  }

  // Probability to move from s to s_next
  private def P(deltaE: Double, k: Int, kmax: Int, kT: Int): Double = {
    exp(-deltaE / T(k, kmax, kT))
  }

  def sa(kmax: Int, kT: Int): Unit = {
    rand.setSeed(System.nanoTime())

    // Create shuffled sequence from 1 to 99
    val temp = Random.shuffle((1 to 99).toList)

    // Initialize path array
    val s = Array.fill(101)(0)
    temp.zipWithIndex.foreach { case (value, index) =>
      s(index + 1) = value // random path from 0 to 0
    }

    println(s"kT = $kT")
    printf("E(s0) %f\n\n", Es(s)) // random starter

    var Emin = Es(s) // E0

    for (k <- 0 to kmax) {
      if (k % (kmax / 10) == 0) {
        printf("k:%10d   T: %8.4f   Es: %8.4f\n", k, T(k, kmax, kT), Es(s))
      }

      val u = 1 + rand.nextInt(99) // city index 1 to 99
      val cv = s(u) + dirs(rand.nextInt(8)) // city number

      if (cv > 0 && cv < 100 && dist(s(u), cv) <= 5) { // valid neighbor
        val v = s.indexOf(cv) // find index of city cv
        if (v > 0) { // valid index found
          val deltae = dE(s, u, v)

          if (deltae < 0 || // always move if negative
              P(deltae, k, kmax, kT) >= rand.nextDouble()) {
            // Swap s(u) and s(v)
            val temp = s(u)
            s(u) = s(v)
            s(v) = temp
            Emin += deltae
          }
        }
      }
    }

    printf("\nE(s_final) %f\n", Emin)
    println("Path:")

    // Output final state
    s.zipWithIndex.foreach { case (value, index) =>
      if (index > 0 && index % 10 == 0) println()
      printf("%4d", value)
    }
    println()
  }

  def main(args: Array[String]): Unit = {
    sa(1000000, 1)
  }
}
