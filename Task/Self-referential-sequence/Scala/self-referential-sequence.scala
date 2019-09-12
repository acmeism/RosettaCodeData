import spire.math.SafeLong

import scala.annotation.tailrec
import scala.collection.parallel.immutable.ParVector

object SelfReferentialSequence {
  def main(args: Array[String]): Unit = {
    val nums = ParVector.range(1, 1000001).map(SafeLong(_))
    val seqs = nums.map{ n => val seq = genSeq(n); (n, seq, seq.length) }.toVector.sortWith((a, b) => a._3 > b._3)
    val maxes = seqs.takeWhile(t => t._3 == seqs.head._3)

    println(s"Seeds: ${maxes.map(_._1).mkString(", ")}\nIterations: ${maxes.head._3}")
    for(e <- maxes.distinctBy(a => nextTerm(a._1.toString))){
      println(s"\nSeed: ${e._1}\n${e._2.mkString("\n")}")
    }
  }

  def genSeq(seed: SafeLong): Vector[String] = {
    @tailrec
    def gTrec(seq: Vector[String], n: String): Vector[String] = {
      if(seq.contains(n)) seq
      else gTrec(seq :+ n, nextTerm(n))
    }
    gTrec(Vector[String](), seed.toString)
  }

  def nextTerm(num: String): String = {
    @tailrec
    def dTrec(digits: Vector[(Int, Int)], src: String): String = src.headOption match{
      case Some(n) => dTrec(digits :+ ((n.asDigit, src.count(_ == n))), src.filter(_ != n))
      case None => digits.sortWith((a, b) => a._1 > b._1).map(p => p._2.toString + p._1.toString).mkString
    }
    dTrec(Vector[(Int, Int)](), num)
  }
}
