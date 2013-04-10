package org.rosettacode

package object ArithmeticComplex {
  val i = Complex(0, 1)

  implicit def fromDouble(d: Double) = Complex(d)
  implicit def fromInt(i: Int) = Complex(i.toDouble)
}

package ArithmeticComplex {
  case class Complex(real: Double = 0.0, imag: Double = 0.0) {
    def this(s: String) =
      this("[\\d.]+(?!i)".r findFirstIn s getOrElse "0" toDouble,
           "[\\d.]+(?=i)".r findFirstIn s getOrElse "0" toDouble)

    def +(b: Complex) = Complex(real + b.real, imag + b.imag)
    def -(b: Complex) = Complex(real - b.real, imag - b.imag)
    def *(b: Complex) = Complex(real * b.real - imag * b.imag, real * b.imag + imag * b.real)
    def inverse = {
      val denom = real * real + imag * imag
      Complex(real / denom, -imag / denom)
    }
    def /(b: Complex) = this * b.inverse
    def unary_- = Complex(-real, -imag)
    lazy val abs = math.hypot(real, imag)
    override def toString = real + " + " + imag + "i"

    def i = { require(imag == 0.0); Complex(imag = real) }
  }

  object Complex {
    def apply(s: String) = new Complex(s)
    def fromPolar(rho:Double, theta:Double) = Complex(rho*math.cos(theta), rho*math.sin(theta))
  }
}
