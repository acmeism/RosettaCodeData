import spire.math.SafeLong
import spire.implicits._

import scala.collection.parallel.immutable.ParVector

object Primorial {
  def main(args: Array[String]): Unit = {
    println(
      s"""|First 10 Primorials:
          |${LazyList.range(0, 10).map(n => f"$n: ${primorial(n).toBigInt}%,d").mkString("\n")}
          |
          |Lengths of Primorials:
          |${LazyList.range(1, 7).map(math.pow(10, _).toInt).map(i => f"$i%,d: ${primorial(i).toString.length}%,d").mkString("\n")}
          |""".stripMargin)
  }

  def primorial(num: Int): SafeLong = if(num == 0) 1 else primesSL.take(num).to(ParVector).reduce(_*_)
  lazy val primesSL: Vector[SafeLong] = 2 +: ParVector.range(3, 20000000, 2).filter(n => !Iterator.range(3, math.sqrt(n).toInt + 1, 2).exists(n%_ == 0)).toVector.sorted.map(SafeLong(_))
}
