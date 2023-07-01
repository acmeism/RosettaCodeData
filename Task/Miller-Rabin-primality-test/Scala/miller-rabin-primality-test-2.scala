import scala.annotation.tailrec
import scala.language.{implicitConversions, postfixOps}
import scala.util.Random

object MillerRabin {

  implicit def int2Bools(b: Int): Seq[Boolean] = 31 to 0 by -1 map isBitSet(b)

  def isBitSet(byte: Int)(bit: Int): Boolean = ((byte >> bit) & 1) == 1

  def mod(num: Int, denom: Int) = if (num % denom >= 0) num % denom else (num % denom) + denom

  @tailrec
  def isSimple(p: Int, s: Int): Boolean = {
    if (s == 0) {
      true
    }
    else if (witness(Random.nextInt(p - 1), p)) {
      false
    }
    else {
      isSimple(p, s - 1)
    }
  }

  def witness(a: Int, p: Int): Boolean = {
    val b: Seq[Boolean] = p - 1

    b.foldLeft(1)((d, b) => if (mod(d * d, p) == 1 && d != 1 && d != p - 1) {
      return true
    } else {
      b match {
        case true => mod(mod(d*d, p)*a,p)
        case false => mod(d*d, p)
      }
    }) != 1
  }
}
