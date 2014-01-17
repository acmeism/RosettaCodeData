object TernaryBit {
    val P = TernaryBit(+1)
    val M = TernaryBit(-1)
    val Z = TernaryBit( 0)

  implicit def asChar(t: TernaryBit): Char = t.charValue
  implicit def valueOf(c: Char): TernaryBit = {
    c match {
      case '0' => 0
      case '+' => 1
      case '-' => -1
      case nc => throw new IllegalArgumentException("Illegal ternary symbol " + nc)
    }
  }
  implicit def asInt(t: TernaryBit): Int = t.intValue
  implicit def valueOf(i: Int): TernaryBit = TernaryBit(i)
}

case class TernaryBit(val intValue: Int) {

    def inverse: TernaryBit = TernaryBit(-intValue)

    def charValue = intValue match {
      case  0 => '0'
      case  1 => '+'
      case -1 => '-'
    }
}

class Ternary(val bits: List[TernaryBit]) {

  def + (b: Ternary) = {
    val sumBits: List[Int] = bits.map(_.intValue).zipAll(b.bits.map(_.intValue), 0, 0).map(p => p._1 + p._2)

    // normalize
    val iv: Tuple2[List[Int], Int] = (List(), 0)
    val (revBits, carry) = sumBits.foldLeft(iv)((accu: Tuple2[List[Int], Int], e: Int) => {
      val s = e + accu._2
      (((s + 1 + 3 * 100) % 3 - 1) :: accu._1 , (s + 1 + 3 * 100) / 3 - 100)
    })

    new Ternary(( TernaryBit(carry) :: revBits.map(TernaryBit(_))).reverse )
  }

  def - (b: Ternary) = {this + (-b)}
  def <<<(a: Int): Ternary = { List.fill(a)(TernaryBit.Z) ++ bits}
  def >>>(a: Int): Ternary = { bits.drop(a) }
  def unary_- = { bits.map(_.inverse) }

  def ** (b: TernaryBit): Ternary = {
    b match {
      case TernaryBit.P => this
      case TernaryBit.M => - this
      case TernaryBit.Z => 0
    }
  }

  def * (mul: Ternary): Ternary = {
    // might be done more efficiently - perform normalize only once
    mul.bits.reverse.foldLeft(new Ternary(Nil))((a: Ternary, b: TernaryBit) => (a <<< 1) + (this ** b))
  }

  def intValue = bits.foldRight(0)((c, a) => a*3 + c.intValue)

  override def toString = new String(bits.reverse.map(_.charValue).toArray)
}

object Ternary {

  implicit def asString(t: Ternary): String = t.toString()
  implicit def valueOf(s: String): Ternary = new Ternary(s.toList.reverse.map(TernaryBit.valueOf(_)))

  implicit def asBits(t: Ternary): List[TernaryBit] = t.bits
  implicit def valueOf(l: List[TernaryBit]): Ternary = new Ternary(l)

  implicit def asInt(t: Ternary): BigInt = t.intValue
  // XXX not tail recursive
  implicit def valueOf(i: BigInt): Ternary = {
    if (i < 0) -valueOf(-i)
    else if (i == 0) new Ternary(List())
    else if (i % 3 == 0) TernaryBit.Z :: valueOf(i / 3)
    else if (i % 3 == 1) TernaryBit.P :: valueOf(i / 3)
    else /*(i % 3 == 2)*/ TernaryBit.M :: valueOf((i + 1)  / 3)
  }
  implicit def intToTernary(i: Int): Ternary = valueOf(i)
}
</scala>

Then these classes can be used in the following way:
<lang scala>
object Main {

  def main(args: Array[String]): Unit = {
    val a: Ternary = "+-0++0+"
    val b: Ternary = -436
    val c: Ternary = "+-++-"
    println(a.toString + " " + a.intValue)
    println(b.toString + " " + b.intValue)
    println(c.toString + " " + c.intValue)
    val res = a * (b - c)
    println(res.toString + " " + res.intValue)
  }

}
