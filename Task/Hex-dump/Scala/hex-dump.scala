object BasedDump:
  // Helper to format a number in the specified base with padding
  private def formatNumber(n: Int, base: Int, pad: Int): String =
    val numStr = Integer.toString(n, base).toUpperCase
    "0" * (pad - numStr.length) + numStr

  // Print a chunk of data in the specified format
  private def basedDump(
                         data: Array[Byte],
                         base: Int,
                         offset: Int,
                         len: Int
                       ): Unit =
    require(base >= 2 && base <= 16, s"display base $base not supported")

    val adjustedLen = if len < 0 then data.length else Math.min(offset + len, data.length)
    val bytes = data.slice(offset, adjustedLen)

    val fullChunkSize =
      if base == 16 then 16
      else if base > 8 then 10
      else if base > 4 then 8
      else 6

    val padSize =
      if base == 16 then 2
      else if base == 2 then 8
      else if base > 7 then 3
      else if base > 3 then 4
      else 5

    val midPad = if base != 2 then " " else ""
    val vl = (padSize + 1) * fullChunkSize + midPad.length
    val halfLen = fullChunkSize / 2
    var pos = offset

    bytes.grouped(fullChunkSize).foreach { chunk =>
      val chunkLen = chunk.length
      val values = chunk.map(b => formatNumber(b & 0xFF, base, padSize) + " ").mkString("")
      val s1 = values.take(halfLen * (padSize + 1)) +
        (if chunkLen > halfLen then midPad + values.drop(halfLen * (padSize + 1)) else "")
      val s2 = chunk.map(b => if b >= 32 && b < 127 then b.toChar else '.').mkString
      println(f"${formatNumber(pos, 16, 8)} ${s1.padTo(vl, ' ')}|$s2|")
      pos += chunkLen
    }

    println(f"${formatNumber(pos - offset, 16, 8)}")

  def hexDump(data: Array[Byte], offset: Int = 0, len: Int = -1): Unit =
    basedDump(data, 16, offset, len)

  def xxdDump(data: Array[Byte], offset: Int = 0, len: Int = -1): Unit =
    basedDump(data, 2, offset, len)

  def decimalDump(data: Array[Byte], offset: Int = 0, len: Int = -1): Unit =
    basedDump(data, 10, offset, len)

@main def main(): Unit = {
  def test(): Unit = {
    val testString = "Rosetta Code is a programming chrestomathy site 😀."
    val utf16 = Array[Byte](0xFF.toByte, 0xFE.toByte) ++ testString.getBytes("UTF-16LE")

    println(s"Hexdump of utf-16 string: $testString")
    BasedDump.hexDump(utf16)

    println(s"\nBinary dump (xxd) of utf-16 string: $testString")
    BasedDump.xxdDump(utf16)

    println(s"\nDecimal dump of utf-16 string: $testString")
    BasedDump.decimalDump(utf16)
  }

  test()
}
