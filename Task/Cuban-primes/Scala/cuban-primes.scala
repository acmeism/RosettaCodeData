import spire.math.SafeLong
import spire.implicits._

import scala.annotation.tailrec
import scala.collection.parallel.immutable.ParVector

object CubanPrimes {
  def main(args: Array[String]): Unit = {
    println(formatTable(cubanPrimes.take(200).toVector, 10))
    println(f"The 100,000th cuban prime is: ${getNthCubanPrime(100000).toBigInt}%,d")
  }

  def cubanPrimes: LazyList[SafeLong] = cubans.filter(isPrime)
  def cubans: LazyList[SafeLong] = LazyList.iterate(SafeLong(0))(_ + 1).map(n => (n + 1).pow(3) - n.pow(3))
  def isPrime(num: SafeLong): Boolean = (num > 1) && !(SafeLong(2) #:: LazyList.iterate(SafeLong(3)){n => n + 2}).takeWhile(n => n*n <= num).exists(num%_ == 0)

  def getNthCubanPrime(num: Int): SafeLong = {
    @tailrec
    def nHelper(rem: Int, src: LazyList[SafeLong]): SafeLong = {
      val cprimes = src.take(100000).to(ParVector).filter(isPrime)
      if(cprimes.size < rem) nHelper(rem - cprimes.size, src.drop(100000))
      else cprimes.toVector.sortWith(_<_)(rem - 1)
    }

    nHelper(num, cubans)
  }

  def formatTable(lst: Vector[SafeLong], rlen: Int): String = {
    @tailrec
    def fHelper(ac: Vector[String], src: Vector[String]): String = {
      if(src.nonEmpty) fHelper(ac :+ src.take(rlen).mkString, src.drop(rlen))
      else ac.mkString("\n")
    }

    val maxLen = lst.map(n => f"${n.toBigInt}%,d".length).max
    val formatted = lst.map(n => s"%,${maxLen + 2}d".format(n.toInt))

    fHelper(Vector[String](), formatted)
  }
}
