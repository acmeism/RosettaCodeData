import java.lang.String.format;

object FloydWarshall extends App {

  val weights = Array(Array(1, 3, -2), Array(2, 1, 4), Array(2, 3, 3), Array(3, 4, 2), Array(4, 2, -1))
  val numVertices = 4

  floydWarshall(weights, numVertices)

  def floydWarshall(weights: Array[Array[Int]], numVertices: Int): Unit = {

    val dist = Array.fill(numVertices, numVertices)(Double.PositiveInfinity)
    for (w <- weights)
      dist(w(0) - 1)(w(1) - 1) = w(2)

    val next = Array.ofDim[Int](numVertices, numVertices)
    for (i <- 0 until numVertices; j <- 0 until numVertices if i != j)
      next(i)(j) = j + 1

    for {
      k <- 0 until numVertices
      i <- 0 until numVertices
      j <- 0 until numVertices
      if dist(i)(k) + dist(k)(j) < dist(i)(j)
    } {
      dist(i)(j) = dist(i)(k) + dist(k)(j)
      next(i)(j) = next(i)(k)
    }

    printResult(dist, next)
  }

  def printResult(dist: Array[Array[Double]], next: Array[Array[Int]]): Unit = {
    println("pair     dist    path")
    for {
      i <- 0 until next.length
      j <- 0 until next.length if i != j
    } {
      var u = i + 1
      val v = j + 1
      var path = format("%d -> %d    %2d     %s", u, v,
                            (dist(i)(j)).toInt, u);
      while (u != v) {
        u = next(u - 1)(v - 1)
        path += s" -> $u"
      }
      println(path)
    }
  }
}
