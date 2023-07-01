import java.io.{PrintWriter, StringWriter}

import Jama.{Matrix, QRDecomposition}

object QRDecomposition extends App {
  val matrix =
    new Matrix(
      Array[Array[Double]](Array(12, -51, 4),
        Array(6, 167, -68),
        Array(-4, 24, -41)))
  val d = new QRDecomposition(matrix)

  def toString(m: Matrix): String = {
    val sw = new StringWriter
    m.print(new PrintWriter(sw, true), 8, 6)
    sw.toString
  }

  print(toString(d.getQ))
  print(toString(d.getR))

}
