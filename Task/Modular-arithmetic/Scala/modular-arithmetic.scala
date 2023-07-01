object ModularArithmetic extends App {
  private val x = new ModInt(10, 13)
  private val y = f(x)

  private def f[T](x: Ring[T]) = (x ^ 100) + x + x.one

  private trait Ring[T] {
    def +(rhs: Ring[T]): Ring[T]

    def *(rhs: Ring[T]): Ring[T]

    def one: Ring[T]

    def ^(p: Int): Ring[T] = {
      require(p >= 0, "p must be zero or greater")
      var pp = p
      var pwr = this.one
      while ( {
        pp -= 1;
        pp
      } >= 0) pwr = pwr * this
      pwr
    }
  }

  private class ModInt(var value: Int, var modulo: Int) extends Ring[ModInt] {
    def +(other: Ring[ModInt]): Ring[ModInt] = {
      require(other.isInstanceOf[ModInt], "Cannot add an unknown ring.")
      val rhs = other.asInstanceOf[ModInt]
      require(modulo == rhs.modulo, "Cannot add rings with different modulus")
      new ModInt((value + rhs.value) % modulo, modulo)
    }

    def *(other: Ring[ModInt]): Ring[ModInt] = {
      require(other.isInstanceOf[ModInt], "Cannot multiple an unknown ring.")
      val rhs = other.asInstanceOf[ModInt]
      require(modulo == rhs.modulo,
        "Cannot multiply rings with different modulus")
      new ModInt((value * rhs.value) % modulo, modulo)
    }

    override def one = new ModInt(1, modulo)

    override def toString: String = f"ModInt($value%d, $modulo%d)"
  }

  println("x ^ 100 + x + 1 for x = ModInt(10, 13) is " + y)

}
