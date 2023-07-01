import Stream._

object MDR extends App {

  def mdr(x: BigInt, base: Int = 10): (BigInt, Long) = {
    def multiplyDigits(x: BigInt): BigInt = ((x.toString(base) map (_.asDigit)) :\ BigInt(1))(_*_)
    def loop(p: BigInt, c: Long): (BigInt, Long) = if (p < base) (p, c) else loop(multiplyDigits(p), c+1)
    loop(multiplyDigits(x), 1)
  }

  printf("%15s\t%10s\t%s\n","Number","MDR","MP")
  printf("%15s\t%10s\t%s\n","======","===","==")
  Seq[BigInt](123321, 7739, 893, 899998, BigInt("393900588225"), BigInt("999999999999")) foreach {x =>
    val (s, c) = mdr(x)
    printf("%15s\t%10s\t%2s\n",x,s,c)
  }
  println

  val mdrs: Stream[Int] => Stream[(Int, BigInt)] = i => i map (x => (x, mdr(x)._1))

  println("MDR: [n0..n4]")
  println("==== ========")
  ((for {i <- 0 to 9} yield (mdrs(from(0)) take 11112 toList) filter {_._2 == i})
    .map {_ take 5} map {xs => xs map {_._1}}).zipWithIndex
    .foreach{p => printf("%3s: [%s]\n",p._2,p._1.mkString(", "))}

}
