object ArithmeticCoding extends App {
  val (radix, strings) = (10, Seq("DABDDB", "DABDDBBDDBA", "ABRACADABRA", "TOBEORNOTTOBEORTOBEORNOT"))
  val fmt = "%-25s=> %19s * %d^%s"

  def arithmeticDecoding( num: BigInt, radix: Int, pwr: Int, freq: Map[Char, Long]): String = {
    var enc = num * BigInt(radix).pow(pwr)
    val base: Long = freq.map { case (_: Char, v: Long) => v }.sum

    // Create the cumulative frequency table
    val cf = cumulativeFreq(freq)
    // Create the dictionary
    val dict0: Map[Long, Char] = cf.map { el: (Char, Long) => (el._2, el._1) }

    var lchar = -1
    val dict: Map[Long, Char] = (0L until base)
      .map { i =>
        val v: Option[Char] = dict0.get(i)
        if (v.isDefined) {
          lchar = v.get.toInt
          (i, v.get)
        } else if (lchar != -1) (i, lchar.toChar)
        else (-1L, ' ')
      }.filter(_ != (-1, ' ')).toMap

    // Decode the input number
    val (bigBase, decoded) = (BigInt(base), new StringBuilder(base.toInt))
    for (i <- base - 1 to 0L by -1) {
      val pow = bigBase.pow(i.toInt)
      val div = enc / pow
      val c = dict(div.longValue)
      val diff = enc - (pow * cf(c))
      enc = diff / freq(c)
      decoded.append(c)
    }
    decoded.mkString
  }

  def cumulativeFreq(freq: Map[Char, Long]): Map[Char, Long] = {
    var total = 0L

    // freq.toSeq.scanLeft(('_', 0L)){ case ((_, acc), (x, y)) => (x, (acc + y))}.filter(_ !=('_', 0L) ).toMap
    freq.toSeq.sortBy(_._1).map { case (k, v) => val temp = total; total += v; (k, temp) }.toMap
  }

  private def arithmeticCoding( str: String, radix: Int): (BigInt, Int, Map[Char, Long]) = {
    val freq = str.toSeq.groupBy(c => c).map { el: (Char, Seq[Char]) =>
      (el._1, el._2.length.toLong)
    }
    val cf = cumulativeFreq(freq)
    var (lower, pf) = (BigInt(0), BigInt(1))

    // Each term is multiplied by the product of the
    // frequencies of all previously occurring symbols
    for (c <- str) {
      lower = (lower * str.length) + cf(c) * pf
      pf = pf * freq(c)
    }
    // Upper bound
    var powr = 0
    val (bigRadix, upper) = (BigInt(radix.toLong), lower + pf)
    do { pf = pf / bigRadix
         if (pf != 0) powr += 1
    } while (pf != 0)
    ((upper - 1) / bigRadix.pow(powr), powr, freq)
  }

  for (str <- strings) {
    val encoded = arithmeticCoding(str, radix)

    def dec =
      arithmeticDecoding(num = encoded._1, radix = radix, pwr = encoded._2, freq = encoded._3)

    println(fmt.format(str, encoded._1, radix, encoded._2))
    if (str != dec) throw new RuntimeException("\tHowever that is incorrect!")
  }
}
