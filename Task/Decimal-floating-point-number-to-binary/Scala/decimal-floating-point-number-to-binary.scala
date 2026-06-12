import java.lang.Long

import scala.annotation.tailrec

object DecimalFloatPoint2Binary extends App {

  def doubleToBin(d: Double): String = {
    require(d >= 0.0, "Only positive values are allowed.")

    def fraction2BinaryFractionString(s: String, frac: Double) = {
      @tailrec
      def loop(acc: String, mid: Double): String = {
        if (mid > 0.0) {
          val r = mid * 2.0
          if (r >= 1.0) loop(acc + "1", r - 1) else loop(acc + "0", r)
        } else acc
      }

      loop(s + ".", frac)
    }

    val whole = math.floor(d).toLong

    fraction2BinaryFractionString(Long.toString(whole, 2), d - whole)
  }

  def binToDec(s: String) = {
    def num = Long.parseLong(s.replace(".", ""), 2)

    def den = Long.parseLong("1" + s.split('.')(1).replace("1", "0"), 2)

    num.toDouble / den
  }

  { // main
    println( { def d = 23.34375;     s"$d\t => ${doubleToBin(d)}" } )
    println( { def s = "1011.11101"; s"$s\t => ${binToDec(s)}"    } )
  }
}
