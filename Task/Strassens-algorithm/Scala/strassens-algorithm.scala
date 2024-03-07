import scala.math

object MatrixOperations {

  type Matrix = Array[Array[Double]]

  implicit class RichMatrix(val m: Matrix) {
    def rows: Int = m.length
    def cols: Int = m(0).length

    def add(m2: Matrix): Matrix = {
      require(
        m.rows == m2.rows && m.cols == m2.cols,
        "Matrices must have the same dimensions."
      )
      Array.tabulate(m.rows, m.cols)((i, j) => m(i)(j) + m2(i)(j))
    }

    def sub(m2: Matrix): Matrix = {
      require(
        m.rows == m2.rows && m.cols == m2.cols,
        "Matrices must have the same dimensions."
      )
      Array.tabulate(m.rows, m.cols)((i, j) => m(i)(j) - m2(i)(j))
    }

    def mul(m2: Matrix): Matrix = {
      require(m.cols == m2.rows, "Cannot multiply these matrices.")
      Array.tabulate(m.rows, m2.cols)((i, j) =>
        (0 until m.cols).map(k => m(i)(k) * m2(k)(j)).sum
      )
    }

    def toString(p: Int): String = {
      val pow = math.pow(10, p)
      m.map(row =>
        row
          .map(value => (math.round(value * pow) / pow).toString)
          .mkString("[", ", ", "]")
      ).mkString("[", ",\n ", "]")
    }
  }

  def toQuarters(m: Matrix): Array[Matrix] = {
    val r = m.rows / 2
    val c = m.cols / 2
    val p = params(r, c)
    (0 until 4).map { k =>
      Array.tabulate(r, c)((i, j) => m(p(k)(0) + i)(p(k)(2) + j))
    }.toArray
  }

  def fromQuarters(q: Array[Matrix]): Matrix = {
    val r = q(0).rows
    val c = q(0).cols
    val p = params(r, c)
    Array.tabulate(r * 2, c * 2)((i, j) => q((i / r) * 2 + j / c)(i % r)(j % c))
  }

  def strassen(a: Matrix, b: Matrix): Matrix = {
    require(
      a.rows == a.cols && b.rows == b.cols && a.rows == b.rows,
      "Matrices must be square and of equal size."
    )
    require(
      a.rows != 0 && (a.rows & (a.rows - 1)) == 0,
      "Size of matrices must be a power of two."
    )

    if (a.rows == 1) {
      return a.mul(b)
    }

    val qa = toQuarters(a)
    val qb = toQuarters(b)

    val p1 = strassen(qa(1).sub(qa(3)), qb(2).add(qb(3)))
    val p2 = strassen(qa(0).add(qa(3)), qb(0).add(qb(3)))
    val p3 = strassen(qa(0).sub(qa(2)), qb(0).add(qb(1)))
    val p4 = strassen(qa(0).add(qa(1)), qb(3))
    val p5 = strassen(qa(0), qb(1).sub(qb(3)))
    val p6 = strassen(qa(3), qb(2).sub(qb(0)))
    val p7 = strassen(qa(2).add(qa(3)), qb(0))

    val q = Array(
      p1.add(p2).sub(p4).add(p6),
      p4.add(p5),
      p6.add(p7),
      p2.sub(p3).add(p5).sub(p7)
    )

    fromQuarters(q)
  }

  private def params(r: Int, c: Int): Array[Array[Int]] = {
    Array(
      Array(0, r, 0, c, 0, 0),
      Array(0, r, c, 2 * c, 0, c),
      Array(r, 2 * r, 0, c, r, 0),
      Array(r, 2 * r, c, 2 * c, r, c)
    )
  }

  def main(args: Array[String]): Unit = {
    val a: Matrix = Array(Array(1.0, 2.0), Array(3.0, 4.0))
    val b: Matrix = Array(Array(5.0, 6.0), Array(7.0, 8.0))
    val c: Matrix = Array(
      Array(1.0, 1.0, 1.0, 1.0),
      Array(2.0, 4.0, 8.0, 16.0),
      Array(3.0, 9.0, 27.0, 81.0),
      Array(4.0, 16.0, 64.0, 256.0)
    )
    val d: Matrix = Array(
      Array(4.0, -3.0, 4.0 / 3.0, -1.0 / 4.0),
      Array(-13.0 / 3.0, 19.0 / 4.0, -7.0 / 3.0, 11.0 / 24.0),
      Array(3.0 / 2.0, -2.0, 7.0 / 6.0, -1.0 / 4.0),
      Array(-1.0 / 6.0, 1.0 / 4.0, -1.0 / 6.0, 1.0 / 24.0)
    )
    val e: Matrix = Array(
      Array(1.0, 2.0, 3.0, 4.0),
      Array(5.0, 6.0, 7.0, 8.0),
      Array(9.0, 10.0, 11.0, 12.0),
      Array(13.0, 14.0, 15.0, 16.0)
    )
    val f: Matrix = Array(
      Array(1.0, 0.0, 0.0, 0.0),
      Array(0.0, 1.0, 0.0, 0.0),
      Array(0.0, 0.0, 1.0, 0.0),
      Array(0.0, 0.0, 0.0, 1.0)
    )

    println("Using 'normal' matrix multiplication:")
    println(
      s"  a * b = ${a.mul(b).map(_.mkString("[", ", ", "]")).mkString("[", ", ", "]")}"
    )
    println(s"  c * d = ${c.mul(d).toString(6)}")
    println(
      s"  e * f = ${e.mul(f).map(_.mkString("[", ", ", "]")).mkString("[", ", ", "]")}"
    )

    println("\nUsing 'Strassen' matrix multiplication:")
    println(
      s"  a * b = ${strassen(a, b).map(_.mkString("[", ", ", "]")).mkString("[", ", ", "]")}"
    )
    println(s"  c * d = ${strassen(c, d).toString(6)}")
    println(
      s"  e * f = ${strassen(e, f).map(_.mkString("[", ", ", "]")).mkString("[", ", ", "]")}"
    )
  }
}
