import spire.math.SafeLong
import spire.implicits._

object LargestNumDivisibleByDigits {
  def main(args: Array[String]): Unit = {
    for(b <- Seq(10, 16)){
      val tStart = System.currentTimeMillis
      val res = getLargestNum(b).toBigInt.toString(b)
      val tDur = System.currentTimeMillis - tStart
      println(s"Base $b: $res [${tDur}ms]")
    }
  }

  def getLargestNum(base: SafeLong): SafeLong = {
    def chkNum(digits: Vector[SafeLong])(num: SafeLong): Boolean = {
      val lst = LazyList.iterate((num%base, num/base)){case (_, src) => (src%base, src/base)}.take(digits.length).map(_._1)
      lst.diff(digits).isEmpty
    }

    def chkChunk(combo: Vector[SafeLong]): Option[SafeLong] = {
      val lcm = combo.reduce(_.lcm(_))
      val ulim = combo.zipWithIndex.map{case (n, i) => n*(base ** i)}.reduce(_+_)
      Iterator.iterate(ulim - (ulim%lcm))(_ - lcm).takeWhile(_ > 0).find(chkNum(combo))
    }

    val baseDigits: Vector[SafeLong] = Vector.range(1, base.toInt).map(SafeLong(_))
    def chkBlock(digits: Iterator[Vector[SafeLong]]): Option[SafeLong] = digits.map(chkChunk).collect{case Some(n) => n}.maxOption
    Iterator.from(base.toInt - 1, -1).map(len => chkBlock(baseDigits.combinations(len))).collect{case Some(n) => n}.next
  }
}
