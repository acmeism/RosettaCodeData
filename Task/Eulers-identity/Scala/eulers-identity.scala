import spire.math.{Complex, Real}

object Scratch extends App{
  //Declare values with friendly names to clean up the final expression
  val e = Complex[Real](Real.e, 0)
  val pi = Complex[Real](Real.pi, 0)
  val i = Complex[Real](0, 1)
  val one = Complex.one[Real]

  println(e.pow(pi*i) + one)
}
