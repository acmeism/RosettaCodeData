object ConjugateTranspose {

  case class Complex(re: Double, im: Double) {
    def conjugate(): Complex = Complex(re, -im)
    def +(other: Complex) = Complex(re + other.re, im + other.im)
    def *(other: Complex) = Complex(re * other.re - im * other.im, re * other.im + im * other.re)
    override def toString(): String = {
      if (im < 0) {
        s"${re}${im}i"
      } else {
        s"${re}+${im}i"
      }
    }
  }

  case class Matrix(val entries: Vector[Vector[Complex]]) {

    def *(other: Matrix): Matrix = {
      new Matrix(
        Vector.tabulate(entries.size, other.entries(0).size)((r, c) => {
          val rightRow = entries(r)
          val leftCol = other.entries.map(_(c))
          rightRow.zip(leftCol)
            .map{ case (x, y) => x * y } // multiply pair-wise
            .foldLeft(new Complex(0,0)){ case (x, y) => x + y } // sum over all
        })
      )
    }

    def conjugateTranspose(): Matrix = {
      new Matrix(
        Vector.tabulate(entries(0).size, entries.size)((r, c) => entries(c)(r).conjugate)
      )
    }

    def isHermitian(): Boolean = {
      this == conjugateTranspose()
    }

    def isNormal(): Boolean = {
      val ct = conjugateTranspose()
      this * ct == ct * this
    }

    def isIdentity(): Boolean = {
      val entriesWithIndexes = for (r <- 0 until entries.size; c <- 0 until entries(r).size) yield (r, c, entries(r)(c))
      entriesWithIndexes.forall { case (r, c, x) =>
        if (r == c) {
          x == Complex(1.0, 0.0)
        } else {
          x == Complex(0.0, 0.0)
        }
      }
    }

    def isUnitary(): Boolean = {
      (this * conjugateTranspose()).isIdentity()
    }

    override def toString(): String = {
      entries.map("  " + _.mkString("[", ",", "]")).mkString("[\n", "\n", "\n]")
    }

  }

  def main(args: Array[String]): Unit = {
    val m = new Matrix(
      Vector.fill(3, 3)(new Complex(Math.random() * 2 - 1.0, Math.random() * 2 - 1.0))
    )
    println("Matrix: " + m)
    println("Conjugate Transpose: " + m.conjugateTranspose())
    println("Hermitian: " + m.isHermitian())
    println("Normal: " + m.isNormal())
    println("Unitary: " + m.isUnitary())
  }

}
