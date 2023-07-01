import spire.math.SafeLong
import spire.implicits._

import scala.annotation.tailrec

object SquareFreeNums {
  def main(args: Array[String]): Unit = {
    println(
      s"""|1 - 145:
          |${formatTable(sqrFree.takeWhile(_ <= 145).toVector, 10)}
          |
          |1T - 1T+145:
          |${formatTable(sqrFreeInit(1000000000000L).takeWhile(_ <= 1000000000145L).toVector, 6)}
          |
          |Square-Free Counts...
          |100: ${sqrFree.takeWhile(_ <= 100).length}
          |1000: ${sqrFree.takeWhile(_ <= 1000).length}
          |10000: ${sqrFree.takeWhile(_ <= 10000).length}
          |100000: ${sqrFree.takeWhile(_ <= 100000).length}
          |1000000: ${sqrFree.takeWhile(_ <= 1000000).length}
          |""".stripMargin)
  }

  def chkSqr(num: SafeLong): Boolean = !LazyList.iterate(SafeLong(2))(_ + 1).map(_.pow(2)).takeWhile(_ <= num).exists(num%_ == 0)
  def sqrFreeInit(init: SafeLong): LazyList[SafeLong] = LazyList.iterate(init)(_ + 1).filter(chkSqr)
  def sqrFree: LazyList[SafeLong] = sqrFreeInit(1)

  def formatTable(lst: Vector[SafeLong], rlen: Int): String = {
    @tailrec
    def fHelper(ac: Vector[String], src: Vector[String]): String = {
      if(src.nonEmpty) fHelper(ac :+ src.take(rlen).mkString, src.drop(rlen))
      else ac.mkString("\n")
    }

    val maxLen = lst.map(n => f"${n.toBigInt}%,d".length).max
    val formatted = lst.map(n => s"%,${maxLen + 2}d".format(n.toBigInt))

    fHelper(Vector[String](), formatted)
  }
}
