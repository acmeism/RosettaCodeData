object AsciiTable extends App {
  val (strtCharVal, lastCharVal, nColumns) = (' '.toByte, '\u007F'.toByte, 6)
  require(nColumns % 2 == 0, "Number of columns must be even.")

  val nChars = lastCharVal - strtCharVal + 1
  val step = nChars / nColumns
  val threshold = strtCharVal + (nColumns - 1) * step

  def indexGen(start: Byte): LazyList[Byte] =
    start #:: indexGen(
      (if (start >= threshold) strtCharVal + start % threshold + 1 else start + step).toByte
    )

  def k(j: Byte): Char = j match {
    case `strtCharVal` => '\u2420'
    case 0x7F => '\u2421'
    case _ => j.toChar
  }

  indexGen(strtCharVal)
    .take(nChars)
    .sliding(nColumns, nColumns)
    .map(_.map(byte => f"$byte%3d : ${k(byte)}"))
    .foreach(line => println(line.mkString("  ")))
}
