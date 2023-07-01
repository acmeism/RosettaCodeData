object Munch {
  def main(args: Array[String]): Unit = {
    import scala.math.pow
    (1 to 5000).foreach {
      i => if (i == (i.toString.toCharArray.map(d => pow(d.asDigit,d.asDigit))).sum)
        println( i + " (munchausen)")
    }
  }
}
