  class TinyInt(val int: Byte) {
    import TinyInt._
    require(int >= lower && int <= upper, "TinyInt out of bounds.")

    override def toString = int.toString
  }

  object TinyInt {
    val (lower, upper) = (1, 10)

    def apply(i: Byte) = new TinyInt(i)
  }

  val test = (TinyInt.lower to TinyInt.upper).map(n => TinyInt(n.toByte))
