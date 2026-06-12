import java.text.DecimalFormat

case class Complex(r: Double = 0, i: Double = 0) {
  def +(c: Complex): Complex = Complex(r = r + c.r, i = i + c.i)

  def -(c: Complex): Complex = Complex(r = r - c.r, i = i - c.i)

  def *(c: Complex): Complex = Complex(r = r * c.r - i * c.i, i = r * c.i + i * c.r)

  def /(c: Complex): Complex = {
    val norm = c.r * c.r + c.i * c.i
    Complex(r = (r * c.r + i * c.i) / norm, i = (i * c.r - r * c.i) / norm)
  }

  override def toString: String = {
    val df = new DecimalFormat("0.#####")
    val real = if (Math.abs(r) < 1E-5) "" else df.format(r)
    val imag = if (Math.abs(i) < 1E-5) "" else "," + df.format(i) + "i"
    s"$real$imag"
  }
}

object Complex {
  implicit class ComplexOps(c: Int | Long | Float | Double) {
    private def double: Double = c match {
      case i: Int => i.toDouble
      case l: Long => l.toDouble
      case f: Float => f.toDouble
      case d: Double => d
    }

    def r: Complex = Complex(r = double)

    def i: Complex = Complex(i = double)
  }
}

import Complex.ComplexOps

import scala.collection.concurrent.TrieMap

object DiscreteFourierTransform extends App {
  private val sample = Seq(2, 3, 5, 7, 11).map(_.r)

  private def dft(x: Seq[Complex], inverse: Boolean = false): Seq[Complex] = {
    require(x.nonEmpty)
    val N = x.size
    val f = (if(inverse) 1 else -1) * Math.TAU / N
    val cache: TrieMap[(Int, Int), Double] = TrieMap.empty

    def getE(k: Int, n: Int): Double = if (n > k) {
      cache.getOrElseUpdate((k, n), f * k * n)
    } else {
      cache.getOrElseUpdate((n, k), f * k * n)
    }

    Seq.range(0, N).map { n =>
      Seq.range(0, N).map { k =>
        val angl = getE(k, n)
        x(k) * Complex(Math.cos(angl), Math.sin(angl))
      }.reduce { case (l, r) => l + r }
    }.map{n => if (inverse) n / N.r else n}
  }

  private def clean(c: Complex): Complex =
    Complex(r = if (Math.abs(c.r) < 1E-5) 0 else c.r, i = if (Math.abs(c.i) < 1E-5) 0 else c.i)

  println(dft(sample).map(clean).mkString(" "))

  println(dft(dft(sample).map(clean), inverse = true).map(clean).mkString(" "))
}
